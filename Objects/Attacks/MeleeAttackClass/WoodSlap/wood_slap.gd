extends MeleeAttack

# rotation gets set at initialization
func launch_attack(_anim_name : String = ""):
	var anim = AttackPlayer.get_animation(attack_animation)
	var track_index = anim.find_track(".:rotation", Animation.TYPE_VALUE)
	var key_index_1 = anim.track_find_key(track_index, 0.0)
	var key_index_2 = anim.track_find_key(track_index, 0.2)
	#anim.track_set_key_value(track_index, key_index_1, rotation - 45)
	#anim.track_set_key_value(track_index, key_index_2, rotation + 45)
	print(rotation - 45)
	print(rotation + 45)
	super(_anim_name)
