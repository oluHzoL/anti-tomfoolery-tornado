extends Node2D

class_name Spawner

@export var entity : PackedScene



# link key names to resource packed scenes
var material_dict : Dictionary = {
	"Stone" : 1
}

# these signals gets connected to the map's resource manager and obstacle manager
signal request_spawn_entity()
signal request_spawn_material()

func spawn_entity():
	pass

func spawn_material():
	pass

func loot_drop():
	pass
