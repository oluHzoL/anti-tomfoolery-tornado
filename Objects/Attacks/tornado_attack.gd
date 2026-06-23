extends Attack
# natural spin-cycle attack exclusive to the tornado
# might give it a class name later who knows

@export var default_radius : float = 200.0

func _ready() -> void:
	reset_radius()
	connect("area_entered", _on_area_entered)
	launch_attack()
	if has_node("MultiHitInterval"): 
		get_node("MultiHitInterval").connect("timeout", multi_hit_interval)

func launch_attack():
	attack_startup = false
	attack_active = true
	set_deferred("visible", true)
	set_deferred("monitoring", true)

func set_radius(rad : float):
	get_node("CollisionShape2D").shape.radius = rad

func reset_radius():
	get_node("CollisionShape2D").shape.radius = default_radius
