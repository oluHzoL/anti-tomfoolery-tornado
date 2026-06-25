extends Node2D

@export var random_death : RNGTable

signal anim_finished()

func play_random_death():
	get_node("AnimationPlayer").play(random_death.return_random_key())
	await get_node("AnimationPlayer").animation_finished
	anim_finished.emit()
