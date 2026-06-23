extends Obstacle
class_name Jester

var fear : bool = false # enum extension workaround
var fearbox : Fearbox # tornado fearbox ref.

func _ready() -> void:
	super()
	hurtbox.connect("area_entered", detect_fear)

func _physics_process(delta: float) -> void:
	match state:
		STATE.ACTIVE:
			var direction : Vector2 = Vector2(1, 0)
			if not fear:
				velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
				#add proper movement ai
			elif fearbox != null:
				direction = (global_position - fearbox.global_position).normalized()
				velocity = velocity.move_toward(direction * speed, acceleration * delta)
			
				if fearbox == null or !hurtbox.overlaps_area(fearbox):
					fear = false
		STATE.KNOCKBACK:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
			
			if velocity == Vector2.ZERO:
				state = STATE.ACTIVE
		STATE.DOWN:
			pass
	move_and_slide()

func detect_fear(area : Area2D):
	if area is Fearbox:
		fear = true
		fearbox = area
