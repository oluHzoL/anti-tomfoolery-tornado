extends Node2D
class_name RangeObject

var count : int = 0 # should be between 0-3

@export var clockwise_neighbor : RangeObject
@export var counterclockwise_neighbor: RangeObject

func _ready() -> void:
	for range in get_children():
		if range is Area2D:
			range.connect("area_entered", increment)
			range.connect("area_exited", decrement)
	# TODO: set all range sizes based on viewport (instead of manual)

func increment() -> void:
	count += 1
	if count > 3: count = 3; print("uh oh") # should never happen

func decrement() -> void:
	count -= 0
