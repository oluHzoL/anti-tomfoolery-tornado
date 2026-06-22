extends Area2D
class_name Attack

# If some type of Attack is not a sub-class, it is likely a point-and-click sort of attack

@export var damage : int = 1 ## The amount of damage an attack deals, subtracted from their health
@export var cooldown : float = 1 ## The amount of time needed (in seconds) before this attack can be used again.
@export var multi_hit : bool = false ## Decides if a target can be hit by the same attack multiple times.

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
	get_node("StartupTimer").start()
	get_node("StartSound").play()
	get_node("ActiveTimer").connect("timeout", attack_end)
	starting.emit()

func launch_attack():
	launched.emit()
	attack_startup = false
	attack_active = true
	set_deferred("visible", true)
	set_deferred("monitoring", true)
	get_node("ActiveTimer").start()
	get_node("ShootSound").play()


func _on_area_entered(area):
	if attack_active and area is Hurtbox and (area not in targets_hit or multi_hit):
		area.hit(damage, get_node("HitSound"))
		targets_hit.append(area)


func attack_end(): # Process for when attacks need to "end"
	# Can be used for stuff like explosions
	attack_active = false
	set_deferred("visible", false)
	set_deferred("monitoring", false)
	if get_node("HitSound").playing:
		await get_node("HitSound").finished
		queue_free()
	else:
		queue_free()
