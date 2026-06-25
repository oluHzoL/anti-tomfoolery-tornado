extends Button
class_name SceneChangeButton

@export var target_scene: String

func _pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
	SceneDataManager.switch_scene(target_scene)
	
