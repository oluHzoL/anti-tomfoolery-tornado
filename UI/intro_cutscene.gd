extends Control

func _ready() -> void:
	get_node("AnimationPlayer").play("cutscene")
