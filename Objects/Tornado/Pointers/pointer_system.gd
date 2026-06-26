extends Node2D

var pointer_pairs : Dictionary[Node2D, Jester]
const pointer := preload("res://Objects/Tornado/Pointers/pointer.tscn")

@export var obstacle_manager : ObstacleManager

func _ready() -> void:
	get_node("Timer").connect("timeout", first_pair)
	obstacle_manager.connect("jester_killed", enable_pointers)

func return_all_jesters():
	var jesters = [] 
	for child in obstacle_manager.get_children():
		if child is Jester:
			jesters.append(child)
	return jesters

func first_pair():
	pair()
	get_node("Timer").disconnect("timeout", first_pair)
	#get_node("Timer").connect("timeout", find_jesters)

func pair():
	var jesters = return_all_jesters()
	for jester in jesters:
		var new_pointer : Node2D = pointer.instantiate()
		add_child(new_pointer)
		pointer_pairs[new_pointer] = jester
	#print(pointer_pairs)

func point(pointer : Node2D):
	if pointer_pairs[pointer] == null:
		pointer_pairs.erase(pointer)
		pointer.queue_free()
		return
	var target_jester = pointer_pairs[pointer]
	#dir = player.position - shooter.position
	#proj.set_rotation((atan2(dir.y, dir.x)))
	var dir = target_jester.global_position - pointer.global_position
	pointer.set_rotation(atan2(dir.y, dir.x))

func enable_pointers():
	if obstacle_manager.jester_count < 30:
		set_deferred("visible", true)

func find_jesters():
	for pointer in pointer_pairs:
		point(pointer)

func _process(delta: float) -> void:
	find_jesters()
