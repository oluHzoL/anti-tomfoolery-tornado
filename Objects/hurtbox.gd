extends Area2D
class_name Hurtbox

var invulnerable : bool = false # alternatively manipulate layer if need be

@export var i_frame_length : float = 0.5

@onready var IFrames : Timer  = get_node("I-Frames")

signal hurt(damage : int)
signal attempt_knockback(power : int, attack_coordinates : Vector2)

func _ready() -> void:
	IFrames.wait_time = i_frame_length
	IFrames.connect("timeout", timeout)

func inflict_damage(damage : int, attack_pos : Vector2, knockback_power : int = 0, i_frame_length : float = IFrames.wait_time) -> void:
	if !invulnerable: 
		hurt.emit(damage)
		inflict_knockback(attack_pos, knockback_power)
		invulnerable = true
		IFrames.start(i_frame_length)

func inflict_knockback(attack_pos : Vector2, knockback_power : int = 0):
	if !invulnerable and knockback_power != 0:
		attempt_knockback.emit(knockback_power, attack_pos)

func timeout() -> void:
	invulnerable = false
