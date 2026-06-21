extends CharacterBody2D

class_name Obstacle

enum STATE{ACTIVE, DEAD}


@export var max_health : int = 10

var health : int = max_health

@onready var hurtbox : Hurtbox = get_node("Hurtbox")

func _ready() -> void:
	hurtbox.connect('hurt', damage)

func add_health(amount : int) -> void:
	health += amount
	if health > max_health: health = max_health

func damage(amount : int) -> void:
	health -= amount
	if health < 0: health = 0
	if health < 0: death()

func death() -> void:
	pass
