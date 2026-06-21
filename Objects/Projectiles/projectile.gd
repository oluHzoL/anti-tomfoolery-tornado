extends Area2D
enum PROJECTILE_TYPE{BULLET, BEAM}

@export var projectile_type : PROJECTILE_TYPE = PROJECTILE_TYPE.BULLET ## Determines the type of projectile. Different types require different code, behavior, etc.
@export var damage_val : int = 1 ## The amount of damage an attack deals, subtracted from their health
@export var speed : int = 500 ## The speed of a projectile.
@export var pierce : bool = false ## If the projectile can damage without disappearing. Beams must pierce.
@export var cooldown : float = 1 ## The amount of time needed (in seconds) before this projectile can be fired again.
var projectile_active = false ## If the projectile is active.
var projectile_startup = false
var shooting_enabled = true ## If the projectile can be fired.
# Toggle if bullets can go thru level using mask
var direction : Vector2
signal starting() ## Communicate when the bullet is starting up.
signal fired() ## Communicates when the bullet is fired.
signal ended() ## Communicates when the bullet sequence has ended

func _ready() -> void:
	if projectile_type == PROJECTILE_TYPE.BEAM: pierce = true
	starting.emit()

func _physics_process(delta):
	position += speed * direction * delta
