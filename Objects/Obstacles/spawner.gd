extends Node2D

class_name Spawner

@export var entity : PackedScene



# link key names to resource packed scenes
@export var material_dex : EntityDex

# these signals gets connected to the map's resource manager and obstacle manager
signal request_spawn_entity(obstacle_name : String, coordinates : Vector2)
signal request_spawn_material(material_name : String, coordinates : Vector2)

func spawn_entity(name : String, coordinates : Vector2i):
	request_spawn_entity.emit(name, self.global_position) # coord placeholder

func spawn_material(material_name : String):
	request_spawn_material.emit(material_name, self.global_position) # coord placeholder

func loot_drop(loot : PackedStringArray):
	for material in loot:
		if material in material_dex.index:
			if not get_parent().alive: #band aid of shame
				spawn_material(material)
		else:
			print(str(material) + " not found in material_dex")
