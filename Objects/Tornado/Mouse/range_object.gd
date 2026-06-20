extends Node2D
class_name RangeObject

enum ORIENTATION{HORIZONTAL, VERTICAL}

signal checkpoint_hit(obj : RangeObject)

const BOOST1 = 5
const BOOST2 = 6
const BOOST3 = 7
 
var count : int = 0 # should be between 0-3
var boost_bonus : int = 0
var boost_given : bool = false
var valid : bool = true

@export var checkpoint_orientation : ORIENTATION = ORIENTATION.HORIZONTAL
@export var clockwise_neighbor : RangeObject
@export var counterclockwise_neighbor: RangeObject

func _ready() -> void:
	for range in get_children():
		if range is Area2D:
			range.connect("area_entered", increment)
			range.connect("area_exited", give_boost)
			range.connect("area_exited", decrement)
	#range_configuration()
	# TODO: set all range sizes based on viewport (instead of manual)

# deprecated until viewport change
func range_configuration():
	var power : int = 1
	var max_range : float = 0
	if checkpoint_orientation == ORIENTATION.HORIZONTAL:
		max_range = get_viewport().size.x
	else:
		max_range = get_viewport().size.y
	print(max_range)
	print(max_range / 2)
	print(max_range / 4)
	print(max_range / 8)
	print(max_range / 16)
	for range in get_children():
		if range is Area2D:
			var CollisionShape : CollisionShape2D = range.get_node("CollisionShape2D")
			print(range)
			if range.name == "Range3":
				power = 1
			elif range.name == "Range2":
				power = 2
			elif range.name == "Range1":
				power = 3
			CollisionShape.shape.size.x = max_range / (pow(2, power))
			CollisionShape.position.x = CollisionShape.shape.size.x / 2.0

func reset() -> void:
	boost_bonus = 0
	boost_given = false

func give_boost(_area : Area2D) -> void:
	if !boost_given:
		if count == 3:
			boost_bonus = BOOST1 # boost lvl 1
		elif count == 2:
			boost_bonus = BOOST2 # boost lvl 2
		elif count == 1:
			boost_bonus = BOOST3 # boost lvl 3
		emit_signal("checkpoint_hit", self)
	boost_given = true
	# TODO: depending on direction, make some neighbor valid

func increment(_area : Area2D) -> void:
	count += 1
	if count > 3: count = 3; print("range overflow") # should never happen

func decrement(_area : Area2D) -> void:
	count -= 1
	if count < 0: count = 0; print("range underflow") # also should never happen
