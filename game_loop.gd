extends Node2D

var game_active : bool = true
var game_paused : bool = false

@onready var attack_manager : AttackManager = get_node("AttackManager")
@onready var material_manager : MaterialManager = get_node("MaterialManager")
@onready var obstacle_manager : ObstacleManager = get_node("ObstacleManager")
@onready var timer : Timer = get_node("Timer")
# ui
@onready var pause_button : Button = get_node("UI/GameplayUI/TopRightUI/PauseButton")
@onready var pause_menu : Control = get_node("UI/PauseMenu")
@onready var unpause_button : Button = pause_menu.get_node("ButtonContainer/UnpauseButton")

func _ready() -> void:
	obstacle_manager.connect("all_jesters_killed", end_game)
	timer.connect("timeout", end_game)
	start_game()
	load_ui()

func load_ui() -> void:
	pause_button.connect("pressed", pause_game)
	pause_menu.set_deferred("visible", false)
	unpause_button.connect("pressed", unpause_game)

func testing() -> void:
	material_manager.spawn_material("Stone", Vector2i(200, 500))
	obstacle_manager.spawn_obstacle("Stone", Vector2i(500, 200))
	obstacle_manager.spawn_obstacle("Jester", Vector2i(-500, -500))
	obstacle_manager.spawn_obstacle("Jester", Vector2i(-700, -500))

func start_game():
	testing()

func pause_game():
	if not game_paused:
		print('pausing game')
		game_paused = true
		pause_menu.set_deferred("visible", true)
		get_tree().paused = true

func unpause_game():
	if game_paused:
		game_paused = false
		pause_menu.set_deferred("visible", false)
		get_tree().paused = false

func end_game(goal_reached : bool = false):
	if game_active:
		if goal_reached:
			timer.stop()
			print("good ending")
		else:
			obstacle_manager.disconnect("all_jesters_killed", end_game)
