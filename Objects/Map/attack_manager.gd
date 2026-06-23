extends Node2D
class_name AttackManager

@export var player : Tornado # For enemy targeting.

# unlike other Manager nodes, each attack frees itself (might be a bad thing, really)

func queue_attack(Attack : PackedScene, attacker : CharacterBody2D, cooldown_timer : Timer):
	var is_player = attacker is Tornado # The mask values and dir change depending on who is the attacker or not
	var attack_inst = Attack.instantiate()
	var dir
	add_child(attack_inst)
	attack_inst.add_to_group("Attacks") #no idea what this does rn
	cooldown_timer.wait_time = attack_inst.cooldown
	cooldown_timer.start() # starts the cooldown
	
	if is_instance_valid(attacker):
		#	print(proj is Area2D)
		if attack_inst is Projectile:
			fire(attack_inst, attacker, is_player)
		else:
			pass
	else:
		attack_inst.queue_free()
	# Here, check for type of attack

func fire(proj : Projectile, shooter : CharacterBody2D, is_player : bool):
	var dir
	if is_player:
		dir = get_local_mouse_position() - shooter.position
		proj.set_collision_mask_value(4, true)
		proj.set_collision_mask_value(2, false)
	else:
		dir = player.position - shooter.position
		proj.set_collision_mask_value(4, false)
		proj.set_collision_mask_value(2, true)
	proj.position = shooter.position
	proj.direction = dir.normalized()
	if proj.ProjectileType == "Beam": #aligns the angle with mouse, allowing for aim with it
		proj.set_rotation((atan2(dir.y, dir.x)))


func attack(attack_inst : Attack, attacker : CharacterBody2D, is_player : bool):
	if is_player:
		attack_inst.position = get_viewport().get_mouse_position()
	else:
		attack_inst.position = player.position

# Here, maybe add special functions like homing, or adding structures.
