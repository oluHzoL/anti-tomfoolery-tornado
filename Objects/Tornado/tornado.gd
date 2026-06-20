extends CharacterBody2D
class_name Tornado

enum State{ACTIVE, CHARGING, EXPIRED}

@export var power = 100 # hits zero, you die; determines speed and such
@export var max_power = 100
@export var speed = 250 # minimum speed 250
@export var acceleration = 800
@export var deceleration = 800

var state : State = State.ACTIVE
var charge : int = 0 #max 100
var move_vector := Vector2.ZERO:
	set(v):
		move_vector = v
		

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

func _process(delta: float) -> void:
	move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# scale speed, size and other things based off of power here
	# use Node2D.scale for easy size manip
func _physics_process(delta: float) -> void:
	match state:
		State.ACTIVE:
			if move_vector.length(): #???
				print("hi")
				velocity = velocity.move_toward(move_vector * speed, acceleration * delta)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
			
			# State Transition
			if Input.is_action_pressed("special"):
				state = State.CHARGING
		
		State.CHARGING:
			#print("charging")
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta * 3)
			
			# State Transition
			if !Input.is_action_pressed("special"):
				state = State.ACTIVE
				# velocity boost based on charge
				velocity = move_vector * speed * 2
			
	move_and_slide()
	
