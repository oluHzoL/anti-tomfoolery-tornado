extends Node2D
class_name AttackManager

@export var player : Tornado # For enemy targeting.

# unlike other Manager nodes, each attack frees itself (might be a bad thing, really)

func _ready() -> void:
	player.get_node("MaterialAttackManager").connect("request_attack", queue_attack)

func queue_attack(Attack : PackedScene, attacker : CharacterBody2D, cooldown_timer : Timer):
	if Attack == null: 
		print("attack unavailable")
		return
	
	var is_player = attacker is Tornado # The mask values and dir change depending on who is the attacker or not
	var attack_inst = Attack.instantiate()
	var dir
	add_child(attack_inst)
	attack_inst.add_to_group("Attacks") #no idea what this does rn
	cooldown_timer.wait_time = attack_inst.cooldown
	cooldown_timer.start() # starts the cooldown
	
	if is_instance_valid(attacker):
		#	print(proj is Area2D)
		if is_player:
			attack_inst.set_collision_mask_value(4, true)
			attack_inst.set_collision_mask_value(2, false)
		else:
			attack_inst.set_collision_mask_value(4, false)
			attack_inst.set_collision_mask_value(2, true)
		if attack_inst is Projectile:
			fire(attack_inst, attacker, is_player)
		elif attack_inst is MeleeAttack:
			melee_attack(attack_inst, attacker, is_player)
		else:
			attack(attack_inst, attacker, is_player)
	else:
		attack_inst.queue_free()
	# Here, check for type of attack

func fire(proj : Projectile, shooter : CharacterBody2D, is_player : bool):
	var dir
	if is_player:
		dir = get_local_mouse_position() - shooter.position
	else:
		dir = player.position - shooter.position
	proj.position = shooter.position
	proj.direction = dir.normalized()
	proj.set_rotation((atan2(dir.y, dir.x)))


func melee_attack(attack_inst : Attack, attacker : CharacterBody2D, is_player : bool):
	var melee_attack_node = Node2D.new()
	add_child(melee_attack_node)
	remove_child(attack_inst)
	melee_attack_node.add_child(attack_inst)
	var dir
	if is_player:
		dir = get_local_mouse_position() - attacker.position
	else:
		dir = player.position - attacker.position
	melee_attack_node.position = attacker.global_position
	attack_inst.position = attacker.global_position
	print("Rotation: " + str(rad_to_deg(atan2(dir.y, dir.x))))
	melee_attack_node.rotation = rad_to_deg(atan2(dir.y, dir.x))
	
	await attack_inst.ended
	melee_attack_node.queue_free()

func attack(attack_inst : Attack, attacker : CharacterBody2D, is_player : bool):
	attack_inst.attacker = attacker
	if is_player:
		print(get_global_mouse_position())
		attack_inst.position = get_global_mouse_position()
	else:
		attack_inst.position = player.position


# Here, maybe add special functions like homing, or adding structures.
