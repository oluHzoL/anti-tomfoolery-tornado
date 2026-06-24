extends Node
class_name MaterialAttackManager

# dict filled with options
# keybinds for each ammo/attack type
# mode switch, click to use
@export var material_dex : EntityDex
@export var DEBUG_ATTACK : PackedScene # TO BE REMOVED


var resource_list : Array[MaterialResource]
var resources_available : Dictionary[MaterialResource, int]# full dict 
var attacks_available : Array[MaterialResource] # first 10 or whatever
var current_attack : int = 0
# [{resource: amount}]
# {resource : amount}

signal available_attacks_changed(list : Array[MaterialResource])
signal request_attack(attack : PackedScene, tornado : CharacterBody2D, timer : Timer)


func _ready() -> void:
	resource_list = material_dex.mat_array # shallow copy
	print(resource_list)
	for resource in resource_list:
		resources_available[resource] = 20 # anything above 0 to test attacks
	change_attacks_available(0)

func change_attacks_available(start_index : int):
	if start_index + 1 > resource_list.size() or start_index < 0:
		print('attack change failed')
		return
	attacks_available = []
	# get 10 (or less) available resources
	for i in range(start_index, start_index + 10):
		attacks_available.append(resource_list[i])
		if i == resource_list.size() - 1: break # prevents out of index from a bad start_index
	available_attacks_changed.emit(attacks_available)

func use_attack(): 
	if current_attack + 1 > attacks_available.size(): #debug
		print("attack unavailable")
		return
	
	if resources_available[attacks_available[current_attack]] > 0:
		resources_available[attacks_available[current_attack]] -= 1
		# don't call get_parent() at home kids
		request_attack.emit(attacks_available[current_attack].attack, get_parent(), get_node("CooldownTimer"))

func _process(delta: float) -> void:
	# heresy
	if Input.is_action_just_pressed("attack_1"):
		current_attack = 0
		print("current attack set")
	elif Input.is_action_just_pressed("attack_2"):
		current_attack = 1
	elif Input.is_action_just_pressed("attack_3"):
		current_attack = 2
	elif Input.is_action_just_pressed("attack_4"):
		current_attack = 3
	elif Input.is_action_just_pressed("attack_5"):
		current_attack = 4
	elif Input.is_action_just_pressed("attack_6"):
		current_attack = 5
	elif Input.is_action_just_pressed("attack_7"):
		current_attack = 6
	elif Input.is_action_just_pressed("attack_8"):
		current_attack = 7
	elif Input.is_action_just_pressed("attack_0"):
		current_attack = 8
	elif Input.is_action_just_pressed("attack_0"):
		current_attack = 9
	elif Input.is_action_just_pressed("debug_attack"): #remove this
		request_attack.emit(DEBUG_ATTACK, get_parent(), get_node("CooldownTimer"))
	
