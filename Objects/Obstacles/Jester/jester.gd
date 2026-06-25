extends Obstacle
class_name Jester

var fear : bool = false # enum extension workaround
var fearbox : Fearbox # tornado fearbox ref.

@onready var death_anim_handler := get_node("DeathAnimHandler")

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
			velocity = Vector2.ZERO
	move_and_slide()

func detect_fear(area : Area2D):
	if area is Fearbox:
		fear = true
		fearbox = area

func death() -> void:
	if alive:
		alive = false
		hurtbox.invulnerable = true #bandaid
		hurtbox.set_deferred("monitoring", false)
		hurtbox.set_deferred("monitorable", false)
		knockback_enabled = false
		state = STATE.DOWN
		death_anim_handler.play_random_death()
		if drops_loot and loot_table != null: loot_table.drop_loot()
		await death_anim_handler.anim_finished
		request_removal.emit(self)
