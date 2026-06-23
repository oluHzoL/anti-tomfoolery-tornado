extends Area2D
class_name Hurtbox

var invulnerable : bool = false # alternatively manipulate layer if need be

@export var i_frame_length : float = 0.5

@onready var IFrames : Timer  = get_node("I-Frames")

signal hurt(damage : int)

func _ready() -> void:
	IFrames.wait_time = i_frame_length
	IFrames.connect("timeout", timeout)

func inflict_damage(damage : int, i_frame_length : float = IFrames.wait_time, knockback : Vector2 = Vector2(0,0)) -> void:
	if !invulnerable: 
		hurt.emit(damage)
		invulnerable = true
		IFrames.start(i_frame_length)
		print('ouch')

func timeout() -> void:
	invulnerable = false
