extends RNGTable
class_name MaterialTable

@export var drop_list : PackedStringArray

signal spawn_loot_request(loot : PackedStringArray)

func drop_loot() -> void:
	# can do more later
	#drop_list.append(return_random_key())
	spawn_loot_request.emit(drop_list)
