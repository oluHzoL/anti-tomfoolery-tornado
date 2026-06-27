extends Control

@export var button : Button

func _ready() -> void:
	button.connect("pressed", enable_music)
	MusicManager.playing = false
	get_node("AnimationPlayer").play("ending")
	await get_node("AnimationPlayer").animation_finished
	get_node("Transition").queue_free()
	
func enable_music():
	MusicManager.playing = true
