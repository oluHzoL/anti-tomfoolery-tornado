extends CharacterBody2D
class_name MaterialBody2D

@export var material_resource_reference : MaterialResource

# doubles as a despawn request; only MaterialManager can free MaterialBody2D nodes
signal collected(material : MaterialBody2D) 

func _ready() -> void:
	get_node("Collectbox").connect("body_entered", collect)
	#if timer's autostart is disabled this does nothing
	get_node("DespawnTimer").connect("timeout", despawn) 
	get_node("DespawnTimer").start()

func collect(body) -> void:
	if body is Tornado:
		# add 1 resource to tornado
		if has_node("CollectSound"):
			get_node("CollectSound").play()
			await get_node("CollectSound").finished
		collected.emit(self)

func despawn() -> void:
	collected.emit(self)

func _physics_process(delta: float) -> void:
	move_and_slide()
