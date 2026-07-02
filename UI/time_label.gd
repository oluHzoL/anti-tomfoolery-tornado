extends Label

func _ready() -> void:
	text = "Time: " + PlayerDataManager.time_to_string()
