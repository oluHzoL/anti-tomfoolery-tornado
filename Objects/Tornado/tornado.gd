extends CharacterBody2D
class_name Tornado

enum State{ACTIVE, CHARGING, EXPIRED}

@onready var SpinManager = get_node('SpinManager')
@onready var SoundManager = get_node('SoundManager')
@onready var AnimPlayer : AnimationPlayer = get_node('AnimationPlayer') # there will probably be a single animation
@onready var tornado_attack : TornadoAttack = get_node('TornadoAttack')

@export var power = 100 # hits zero, you die; determines speed and such
@export var max_power = 1000
@export var speed = 500 # minimum speed 250
@export var acceleration = 800
@export var deceleration = 800
@export var charge_scale : Curve

var state : State = State.ACTIVE
var score : int = 0
var charge : int = 0 #max 100
var move_vector := Vector2.ZERO:
	set(v):
		move_vector = v
		
var prev_move_vector := Vector2(1, 0)

signal charge_boosted()
signal charge_released()
# keybind dict

func _ready() -> void:
	SpinManager.get_node("MouseLayer/MouseCheckpoints").connect("full_circle", add_charge)
	spawn()

func spawn() -> void:
	state = State.ACTIVE
	charge = 0
	move_vector = Vector2.ZERO
	SpinManager.process_mode = Node.PROCESS_MODE_DISABLED
	AnimPlayer.play("Tornado_Rotate")
	SoundManager.get_node("Ambiance").play()

func add_power(amount : int):
	power += amount
	if power > max_power:
		power = max_power

func subtract_power(amount : int):
	power -= amount
	if power < 0: power = 0
	if power == 0:
		print('oh no')

func add_charge(amount : int):
	charge += amount
	charge_boosted.emit()
	if charge > 100:
		charge = 100
	else:
		AnimPlayer.speed_scale += 2
		tornado_attack.add_radius(130)

func remove_control():
	state = State.EXPIRED

func _process(delta: float) -> void:
	move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# # TODO: deal with diagonal vectors (you'd have to let go of both buttons at once otherwise)
	# an idea: if within 0.05 seconds the move_vector does not become zero, set prev_move_vector
	if move_vector != Vector2.ZERO: prev_move_vector = move_vector
	# TODO:
	# scale speed, size, anim speed, and other things based off of power here
	# use Node2D.scale for easy size manip
	
	# select material attack of choice
	

func _physics_process(delta: float) -> void:
	match state:
		State.ACTIVE:
			if move_vector.length():
				velocity = velocity.move_toward(move_vector * speed, acceleration * delta)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
			
			
			if Input.is_action_just_pressed("use_attack"):
				# come up with more elegant regions some day
				var region = Rect2(1700, -1080, 420, 200)
				if not region.has_point(get_local_mouse_position()): # prevents pause button fire
					get_node("MaterialAttackManager").use_attack() # add a safeguard for clicking on UI
			# State Transition
			if Input.is_action_pressed("special"):
				state = State.CHARGING
				SpinManager.process_mode = Node.PROCESS_MODE_INHERIT
				
				# fx
				SoundManager.get_node("ChargeNoise").play()
				AnimPlayer.speed_scale = 2
			
		
		State.CHARGING:
			#print("charging")
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta * 3)
			
			# State Transition
			if !Input.is_action_pressed("special"):
				state = State.ACTIVE
				# velocity boost based on charge
				print("Charge: " + str(charge))
				print("Scale: " + str(charge_scale.sample(charge)))
				print("Boost Velocity: " + str(prev_move_vector * speed * charge_scale.sample(charge)))
				if charge > 20:
					velocity = prev_move_vector * speed * charge_scale.sample(charge)
				SpinManager.process_mode = Node.PROCESS_MODE_DISABLED
				tornado_attack.reset_radius()
				
				
				SoundManager.get_node("ChargeNoise").stop()
				if charge > 20:
					tornado_attack.charge_bonus(charge)
					SoundManager.get_node("Release").play()
				charge = 0 
				AnimPlayer.speed_scale = 1
				charge_released.emit()
				
		State.EXPIRED:
			pass
			
	move_and_slide()
	
