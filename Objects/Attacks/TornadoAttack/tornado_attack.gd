extends Attack
class_name TornadoAttack
# natural spin-cycle attack exclusive to the tornado
# might give it a class name later who knows

var default_damage : int

@export var default_radius : float = 200.0

func _ready() -> void:
	reset_radius()
	connect("area_entered", _on_area_entered)
	launch_attack()
	if has_node("MultiHitInterval"): 
		get_node("MultiHitInterval").connect("timeout", multi_hit_interval)
	get_node("ChargeBonusTimer").connect("timeout", reset_damage)
	default_damage = damage

func launch_attack():
	attack_startup = false
	attack_active = true
	set_deferred("visible", true)
	set_deferred("monitoring", true)

func set_radius(rad : float):
	get_node("CollisionShape2D").shape.radius = rad

func add_radius(rad : float):
	get_node("CollisionShape2D").shape.radius += rad

func reset_radius():
	get_node("CollisionShape2D").shape.radius = default_radius

func charge_bonus(charge : int):
	damage += charge / 25
	get_node("ChargeBonusTimer").start()
	
func reset_damage():
	damage = default_damage
