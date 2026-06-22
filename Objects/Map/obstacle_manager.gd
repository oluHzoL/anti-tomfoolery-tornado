extends Node2D
class_name ObstacleManager

var obstacle_count : int = 0
var jester_count : int = 0

func spawn_obstacle(coordinates : Vector2i, obstacle_scene : PackedScene) -> void:
	obstacle_count += 1
	# if jester, add jester count

func remove_obstacle() -> void:
	obstacle_count -= 1
	# if jester, remove jester count
