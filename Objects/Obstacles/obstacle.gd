extends CharacterBody2D

class_name Obstacle

enum STATE{ACTIVE, KNOCKBACK, DOWN}


@export var max_health : int
@export var drops_loot : bool = true
@export var loot_table : MaterialTable
@export var knockback_enabled : bool = false
@export var knockback_resistance : int = 0
@export var speed : int = 0
@export var acceleration : int = 0
@export var deceleration : int = 1000

var health : int
var state : STATE = STATE.ACTIVE
var alive : bool = true

@onready var hurtbox : Hurtbox = get_node("Hurtbox")
@onready var health_bar = get_node("HPUIControl/HealthBar")

signal request_removal(obs : Obstacle)
signal request_attack(obs : Obstacle, attack : PackedScene, timer : Timer)

func _ready() -> void:
	health = max_health
	hurtbox.connect('hurt', damage)
	hurtbox.connect('attempt_knockback', knockback)
	if drops_loot and loot_table != null: loot_table.connect('spawn_loot_request', get_node("Spawner").loot_drop)
	
	health_bar.max_value = max_health
	health_bar.value = health

func add_health(amount : int) -> void:
	health += amount
	if health > max_health: health = max_health
	health_bar.value = health

func damage(amount : int) -> void:
	if not alive: return
	health -= amount
	if health < 0: health = 0
	health_bar.value = health
	if not health_bar.is_visible_in_tree(): health_bar.set_deferred("visible", true)
	if health <= 0: 
		death()

func knockback(power : int, origin : Vector2):
	var knockback_power = abs(power) - knockback_resistance
	if knockback_power < 0 or not knockback_enabled: return
	if power < 0: knockback_power = -knockback_power # negative knockback (pulling inward)
	var direction : Vector2 = (global_position - origin).normalized() # hope im not wrong
	velocity = direction * power
	state = STATE.KNOCKBACK

func death() -> void:
	# disable many things
	if alive:
		alive = false
		hurtbox.invulnerable = true #bandaid
		hurtbox.set_deferred("monitoring", false)
		hurtbox.set_deferred("monitorable", false)
		if drops_loot and loot_table != null: loot_table.drop_loot()
		request_removal.emit(self)
	# check for spawner; if none exists (which is unusual) then queue free
	

func _physics_process(delta: float) -> void:
	match state:
		STATE.ACTIVE:
			pass
		STATE.KNOCKBACK:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
			
			if velocity == Vector2.ZERO:
				state = STATE.ACTIVE
		STATE.DOWN:
			pass
	move_and_slide()
