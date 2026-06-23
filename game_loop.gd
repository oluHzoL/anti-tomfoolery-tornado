extends Node2D

@onready var attack_manager : AttackManager = get_node("AttackManager")
@onready var material_manager : MaterialManager = get_node("MaterialManager")
@onready var obstacle_manager : ObstacleManager = get_node("ObstacleManager")


func _ready() -> void:
	# connect player to attack manager's queue attack
	
	start_game()

func testing() -> void:
	material_manager.spawn_material("Stone", Vector2i(200, 500))
	obstacle_manager.spawn_obstacle("Stone", Vector2i(500, 200))

func start_game():
	testing()

func pause_game():
	pass

func unpause_game():
	pass

func end_game(goal_reached : bool):
	pass
