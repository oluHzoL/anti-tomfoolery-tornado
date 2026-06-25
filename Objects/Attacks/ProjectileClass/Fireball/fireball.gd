extends Projectile

var default_shape : CircleShape2D
var exploding : bool = false
@export var explosion_radius : int = 500
@onready var anim_player := get_node("AnimationPlayer")

func _ready() -> void:
	super()
	default_shape = get_node("CollisionShape2D").shape
	anim_player.connect("animation_finished", attack_end.unbind(1))

func _on_area_entered(area):
	# Attack._on_area_entered(area) # cant do this
	if attack_active and area is Hurtbox and (area not in targets_hit or multi_hit):
		if not area.invulnerable:
			area.inflict_damage(damage, global_position, knockback_power)
			get_node("HitSound").play()
			if area not in targets_hit:
				targets_hit.append(area)
			if multi_hit:
				get_node("MultiHitInterval").start()
			#explode()
			call_deferred("explode")

func explode():
	exploding = true
	get_node("CollisionShape2D").set("shape", CircleShape2D.new())
	get_node("CollisionShape2D").shape.set("radius", explosion_radius)
	rotation = 0
	anim_player.play("explode")


func attack_end():
	if not exploding:
		anim_player.disconnect("animation_finished", attack_end)
		explode()
		await anim_player.animation_finished
	get_node("CollisionShape2D").shape = default_shape
	super()

func _physics_process(delta: float) -> void:
	if not exploding:
		super(delta)
