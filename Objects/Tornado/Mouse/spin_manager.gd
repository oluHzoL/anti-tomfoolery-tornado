extends Node

var mouse_pos
@onready var mouse_box = get_node("MouseLayer/MouseArea2D")

func _ready() -> void:
	#mouse_box.position = get_viewport().size / 2
	pass

func _process(delta: float) -> void:
	mouse_pos = get_viewport().get_mouse_position()
	mouse_box.position = mouse_pos
