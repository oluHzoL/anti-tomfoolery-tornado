extends CharacterBody2D
class_name MaterialBody2D

@export var material_resource_reference : MaterialResource
@export var speed : int = 500
@export var deceleration : int = 1000
# doubles as a despawn request; only MaterialManager can free MaterialBody2D nodes
signal collected(material : MaterialBody2D) 

func _ready() -> void:
	get_node("Collectbox").connect("body_entered", collect)
	#if timer's autostart is disabled this does nothing
	get_node("DespawnTimer").connect("timeout", despawn) 
	get_node("DespawnTimer").start()
	random_knockback()

func collect(body) -> void:
	if body is Tornado:
		body.get_node("MaterialAttackManager").resources_available[material_resource_reference] += 1
		body.get_node("MaterialAttackManager").material_gained.emit()
		if has_node("CollectSound"):
			get_node("CollectSound").play()
			await get_node("CollectSound").finished
		collected.emit(self)

func random_knockback():
	var x = randf_range(-1, 1)
	var y = randf_range(-1, 1)
	var vector := Vector2(x, y)
	velocity = vector * speed

func despawn() -> void:
	collected.emit(self)

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	move_and_slide()
