extends Area2D
class_name Attack

# If some type of Attack is not a sub-class, it is likely a point-and-click sort of attack

@export var damage : int = 1 ## The amount of damage an attack deals, subtracted from their health
@export var cooldown : float = 1 ## The amount of time needed (in seconds) before this attack can be used again.
@export var multi_hit : bool = false ## Decides if a target can be hit by the same attack multiple times.
@export var knockback_power : int = 0

# might be used in the future for a more sophisticated system
# for now, gotta use what works
enum ATTACK_STATE {STARTUP, ACTIVE, EXPIRING} 

var attack_active = false ## If the attack is active.
var attack_startup = false
var targets_hit : Array[Hurtbox] = []
var attack_enabled = true ## If the attack can be used.

signal starting() ## Communicate when the attack is starting up.
signal launched() ## Communicates when the attack is launched.
signal ended() ## Communicates when the attack sequence has ended.

func _ready() -> void:
	attack_startup = true
	attack_active = false
	set_deferred("visible", false)
	set_deferred("monitoring", false)
	connect("area_entered", _on_area_entered)
	get_node("StartupTimer").connect("timeout", launch_attack)
	get_node("ActiveTimer").connect("timeout", attack_end)
	get_node("StartupTimer").start()
	get_node("StartSound").play()
	if has_node("MultiHitInterval"): 
		get_node("MultiHitInterval").connect("timeout", multi_hit_interval)
	starting.emit()

func launch_attack():
	launched.emit()
	attack_startup = false
	attack_active = true
	set_deferred("visible", true)
	set_deferred("monitoring", true)
	get_node("ActiveTimer").start()
	get_node("AttackSound").play()

# Note: attacks (class extensions) that are meant to end should call super() then attack_end()
func _on_area_entered(area):
	if attack_active and area is Hurtbox and (area not in targets_hit or multi_hit):
		if not area.invulnerable:
			area.inflict_damage(damage, global_position, knockback_power)
			get_node("HitSound").play()
			if area not in targets_hit:
				targets_hit.append(area)
			if multi_hit:
				get_node("MultiHitInterval").start()

func multi_hit_interval():
	for area in targets_hit:
		if overlaps_area(area) and attack_active:
			if not area.invulnerable:
				_on_area_entered(area)
			else:
				get_node("MultiHitInterval").start()



func attack_end(): # Process for when attacks need to "end"
	# Can be used for stuff like explosions
	attack_active = false
	set_deferred("visible", false)
	set_deferred("monitoring", false)
	if get_node("HitSound").playing:
		await get_node("HitSound").finished
	if get_node("AttackSound").playing:
		await get_node("AttackSound").finished
	ended.emit()
	queue_free()
