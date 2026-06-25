extends Node
class_name SceneManager 

## A global node that manages the scenes within the project.
##
## A globalized node that manages how each scene in the project is handled. 
## This node can add, remove, switch, and hide scenes.
## Credit to Night Quest Games for the framework.
##
## @tutorial: https://www.nightquestgames.com/changing-scenes-in-godot-4-is-easy/

## A collection of scenes in the game. Scenes are added through the Inspector panel. 
## The key will be a string of the scene's name or alias, and its value should be the StringName of corresponding scene's path. [br][br]
## In the future, this variable may no longer be an export. Instead, it will read each file name,
## define it as the keys, and use the corresponding filenames (converted to [StringName] as values.
@export var scenes : Dictionary[String, StringName] = {}

## Name of the currently selected scene.
var currentscene_name : String = ""

# Description: Find the initial scene as defined in the project settings
func _ready() -> void:
	#var mainScene : StringName = ProjectSettings.get_setting("application/run/main_scene")
	#print(mainScene)
	#currentscene_name = scenes.find_key(mainScene)
	currentscene_name = scenes.find_key("res://UI/intro_cutscene.tscn")

## Add a new scene to the scene collection. [br]
## [param sceneAlias]: The alias used for finding the scene in the collection. [br]
## [param scenePath]: The full path to the scene file in the file system.
func add_scene(sceneAlias : String, scenePath : String) -> void:
	scenes[sceneAlias] = scenePath
 
## Remove an existing scene from the scene collection. [br]
## [param sceneAlias]: The scene alias of the scene to remove from the collection.
func remove_scene(sceneAlias : String) -> void:
	scenes.erase(sceneAlias)
 
## Switch to the requested scene based on its alias. [br]
## [param sceneAlias]: The scene alias of the scene to switch to.
func switch_scene(sceneAlias : String) -> void:
	get_tree().change_scene_to_file(scenes[sceneAlias])
 
## Restart the current scene.
func restart_scene() -> void:
	get_tree().reload_current_scene()
	 
## Quit the game.
func quit_game() -> void:
	get_tree().quit()

## Return the number of scenes in the collection.
func get_scene_count() -> int:
	return scenes.size()
	 
## Returns the alias of the current scene.
func get_currentscene_name() -> String:
	return currentscene_name
