extends Attack
class_name MeleeAttack
# usually is a melee attack of some kind
# but is generally an attack that relies on an AnimationPlayer
# note that these kinds of attacks will still be rotated like any projectile 

var attacker : CharacterBody2D

@export var start_animation : String = ""
@export var attack_animation : String # in the future, change this to an array that holds any number of these

@onready var AttackPlayer : AnimationPlayer = get_node("AttackPlayer")

# all attack should have at least 0.05s startup
func _ready() -> void:
	attack_startup = true
	attack_active = false
	set_deferred("visible", false)
	set_deferred("monitoring", false)
	connect("area_entered", _on_area_entered)
	if has_node("MultiHitInterval"): 
		get_node("MultiHitInterval").connect("timeout", multi_hit_interval)
	starting.emit()
	if start_animation != "": 
		AttackPlayer.play(start_animation)
		AttackPlayer.connect("animation_finished", launch_attack)
	elif has_node("StartupTimer"):
		get_node("StartupTimer").connect("timeout", launch_attack)
		get_node("StartupTimer").start()
	else:
		print("melee abort")
		queue_free()

func launch_attack(_anim_name : String = ""):
	if start_animation != "": 
		AttackPlayer.disconnect("animation_finished", launch_attack)
	launched.emit()
	attack_startup = false
	attack_active = true
	set_deferred("visible", true)
	set_deferred("monitoring", true)
	AttackPlayer.play(attack_animation) # play some given animation
	AttackPlayer.connect("animation_finished", attack_end)

func attack_end(_anim_name : String = ""):
	attack_active = false
	set_deferred("visible", false)
	set_deferred("monitoring", false)
	ended.emit()
	queue_free()

func _physics_process(delta: float) -> void:
	#print(attacker == null)
	if attack_active and attacker != null:
		print("following")
		position = attacker.global_position
