extends RNGTable
class_name MaterialTable

var loot_array : PackedStringArray

signal spawn_loot_request(loot : PackedStringArray)

func drop_loot() -> void:
	# can do more later
	loot_array.append(return_random_key())
	spawn_loot_request.emit(loot_array)
