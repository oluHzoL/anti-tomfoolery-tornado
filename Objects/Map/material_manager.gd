extends Node2D
class_name MaterialManager

var material_count : int = 0

# my pride is hurting
# make this global maybe
@export var material_dex : EntityDex

func _ready() -> void:
	# will only be used for testing purposes, initializing will be handled by 
	# game_loop.gd (Map node)
	pass
	

func spawn_material(material_name : String, coords : Vector2i):
	var material_inst = material_dex.index[material_name].instantiate()
	if material_inst is not MaterialBody2D:
		material_inst.queue_free()
		# some error here
		return
	call_deferred("add_child", material_inst) # prevent state change during physics loop
	material_inst.position = coords
	material_inst.connect("collected", remove_material)
	material_count += 1
	# connect

func remove_material(material : MaterialBody2D):
	material.queue_free()
	material_count -= 1
