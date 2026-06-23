extends CharacterBody2D

class_name Obstacle

enum STATE{ACTIVE, DEAD}


@export var max_health : int
@export var drops_loot : bool = true
@export var loot_table : MaterialTable

var health : int

@onready var hurtbox : Hurtbox = get_node("Hurtbox")
@onready var health_bar = get_node("HPUIControl/HealthBar")

signal request_removal(obs : Obstacle)
signal request_attack(obs : Obstacle, attack : PackedScene, timer : Timer)

func _ready() -> void:
	health = max_health
	hurtbox.connect('hurt', damage)
	if drops_loot: loot_table.connect('spawn_loot_request', get_node("Spawner").loot_drop)
	
	health_bar.max_value = max_health
	health_bar.value = health

func add_health(amount : int) -> void:
	health += amount
	if health > max_health: health = max_health
	health_bar.value = health

func damage(amount : int) -> void:
	health -= amount
	print(str(self) + " health: " + str(health))
	if health < 0: health = 0
	health_bar.value = health
	if not health_bar.is_visible_in_tree(): health_bar.set_deferred("visible", true)
	if health <= 0: death()

func death() -> void:
	# disable many things
	if drops_loot: loot_table.drop_loot()
	request_removal.emit(self)
	# check for spawner; if none exists (which is unusual) then queue free
	
