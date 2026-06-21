extends CharacterBody2D
class_name Tornado

enum State{ACTIVE, CHARGING, EXPIRED}

@onready var SpinManager = get_node('SpinManager')
@onready var SoundManager = get_node('SoundManager')
@onready var AnimPlayer : AnimationPlayer = get_node('AnimationPlayer') # there will probably be a single animation

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
		
var prev_move_vector := Vector2.ZERO

func _ready() -> void:
	SpinManager.get_node("MouseLayer/MouseCheckpoints").connect("full_circle", add_charge)
	spawn()

func spawn() -> void:
	state = State.ACTIVE
	charge = 0
	move_vector = Vector2.ZERO
	SpinManager.process_mode = Node.PROCESS_MODE_DISABLED
	AnimPlayer.play("Tornado_Rotate")

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
	if charge > 100:
		charge = 100
	else:
		AnimPlayer.speed_scale += 1

func _process(delta: float) -> void:
	move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# # TODO: deal with diagonal vectors (you'd have to let go of both buttons at once otherwise)
	if move_vector != Vector2.ZERO: prev_move_vector = move_vector
	# TODO:
	# scale speed, size, anim speed, and other things based off of power here
	# use Node2D.scale for easy size manip

func _physics_process(delta: float) -> void:
	match state:
		State.ACTIVE:
			if move_vector.length():
				velocity = velocity.move_toward(move_vector * speed, acceleration * delta)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
			
			# State Transition
			if Input.is_action_pressed("special"):
				state = State.CHARGING
				SpinManager.process_mode = Node.PROCESS_MODE_INHERIT
				
				# sound
				SoundManager.get_node("ChargeNoise").play()
		
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
				velocity = prev_move_vector * speed * charge_scale.sample(charge)
				
				SpinManager.process_mode = Node.PROCESS_MODE_DISABLED
				
				# fx
				if charge < 20:
					SoundManager.get_node("ChargeNoise").stop()
				charge = 0 
				AnimPlayer.speed_scale = 1
			
	move_and_slide()
	
