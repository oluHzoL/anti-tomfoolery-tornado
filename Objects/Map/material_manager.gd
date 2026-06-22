extends Node2D

var material_count : int = 0

func _ready() -> void:
	# will only be used for testing purposes, initializing will be handled by 
	# game_loop.gd (Map node)
	pass
	

func spawn_material():
	material_count += 1
	# connect

func remove_material():
	pass
