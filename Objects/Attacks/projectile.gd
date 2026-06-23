extends Attack
class_name Projectile
enum PROJECTILE_TYPE{BULLET, BEAM}

@export var projectile_type : PROJECTILE_TYPE = PROJECTILE_TYPE.BULLET ## Determines the type of projectile. Different types require different code, behavior, etc.
@export var speed : int = 500 ## The speed of a projectile.
@export var pierce : bool = false ## If the projectile can damage without disappearing. Beams must pierce.

# Toggle if bullets can go thru level using mask
var direction : Vector2


func _ready() -> void:
	if projectile_type == PROJECTILE_TYPE.BEAM: pierce = true
	super()

func _on_area_entered(area):
	super(area)
	if attack_active and area is Hurtbox and !pierce:
		attack_end()

func _physics_process(delta):
	position += speed * direction * delta
