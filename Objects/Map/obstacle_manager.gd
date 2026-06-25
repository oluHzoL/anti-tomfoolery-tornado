extends Node2D
class_name ObstacleManager

var obstacle_count : int = 0
var jester_count : int = 0

@export var obstacle_dex : EntityDex
@export var attack_manager : AttackManager
@export var material_manager : MaterialManager # for drops

signal jester_killed()
signal all_jesters_killed()

func spawn_obstacle(obstacle_name : String, coordinates : Vector2i):
	var obstacle = obstacle_dex.index[obstacle_name].instantiate()
	if obstacle is not Obstacle:
		print("spawn obstacle error")
		return null
	add_child(obstacle)
	obstacle_count += 1
	obstacle.position = coordinates
	obstacle.connect("request_removal", remove_obstacle)
	obstacle.connect("request_attack", attack_manager.queue_attack)
	obstacle.get_node("Spawner").connect("request_spawn_entity", spawn_obstacle)
	obstacle.get_node("Spawner").connect("request_spawn_material", material_manager.spawn_material)
	# if jester, add jester count
	if obstacle is Jester: jester_count += 1

func remove_obstacle(obstacle : Obstacle) -> void:
	obstacle_count -= 1
	if obstacle is Jester: 
		jester_count -= 1
		jester_killed.emit()
	obstacle.queue_free()
	if jester_count == 0:
		all_jesters_killed.emit(true)
	# if jester, remove jester count
