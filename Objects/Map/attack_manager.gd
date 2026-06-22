extends Node2D
@export var Player : Tornado # For enemy targeting.

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
			pass
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
		dir = Player.position - shooter.position
		proj.set_collision_mask_value(4, false)
		proj.set_collision_mask_value(2, true)
	proj.position = shooter.position
	proj.direction = dir.normalized()
	if proj.ProjectileType == "Beam": #aligns the angle with mouse, allowing for aim with it
		proj.set_rotation((atan2(dir.y, dir.x)))


func attack(attack_inst : Attack, is_player : bool):
	pass

# Here, maybe add special functions like homing, or adding structures.
