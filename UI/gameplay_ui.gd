extends Control

@export var obstacle_manager : ObstacleManager
@export var tornado : Tornado
@export var game_timer : Timer


@onready var jester_count : Label = get_node("UpperLeftUI/JesterCountLabel")
@onready var time_left : Label = get_node("UpperLeftUI/TimeLeftLabel")
@onready var interval : Timer = time_left.get_node("Interval")
@onready var boost_bar := get_node("BoostBar")
@onready var hotbar_ui := get_node("HotbarUI")

func _ready() -> void:
	obstacle_manager.connect("jester_killed", update_jester_count)
	interval.connect("timeout", update_time_left)
	tornado.connect("charge_boosted", update_boost)
	tornado.connect("charge_released", update_boost)
	tornado.get_node("MaterialAttackManager").connect("attack_used", update_hotbar_counts)
	tornado.get_node("MaterialAttackManager").connect("material_gained", update_hotbar_counts)
	tornado.get_node("MaterialAttackManager").connect("equip_changed", update_hotbar_equip)
	#update_jester_count()
	#update_time_left()

func update_jester_count() -> void:
	jester_count.text = "Jesters left: " + str(obstacle_manager.jester_count)

func update_time_left() -> void:
	time_left.text = "Time left: " + str(int(game_timer.time_left))

func update_boost() -> void:
	boost_bar.value = tornado.charge

func update_hotbar_counts() -> void:
	for i in range(hotbar_ui.get_child_count()):
		# this is gonna be ugly
		#resources_available[attacks_available[current_attack]]
		var mam = tornado.get_node("MaterialAttackManager")
		var amount = mam.resources_available[mam.attacks_available[i]]
		hotbar_ui.get_child(i).get_node("Amount").text = "x" + str(amount)

func update_hotbar_equip(index : int) -> void:
	var target_container = hotbar_ui.get_child(index)
