extends Control

@export var obstacle_manager : ObstacleManager
@export var tornado : Tornado
@export var game_timer : Timer


@onready var jester_count : Label = get_node("UpperLeftUI/JesterCountLabel")
@onready var time_left : Label = get_node("UpperLeftUI/TimeLeftLabel")
@onready var interval : Timer = time_left.get_node("Interval")

func _ready() -> void:
	obstacle_manager.connect("jester_killed", update_jester_count)
	interval.connect("timeout", update_time_left)
	await obstacle_manager.ready
	print('updating')
	update_jester_count()
	update_time_left()

func update_jester_count() -> void:
	jester_count.text = "Jesters left: " + str(obstacle_manager.jester_count)

func update_time_left() -> void:
	time_left.text = "Time left: " + str(int(game_timer.time_left))
