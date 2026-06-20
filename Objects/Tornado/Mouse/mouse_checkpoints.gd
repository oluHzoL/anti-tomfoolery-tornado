extends Node2D
class_name MouseCheckpointSystem

# TODO: breaking the cycle causes the range object to not reset 
# boost_given remains true instead of becoming false

enum STATE{INACTIVE, CLOCKWISE, COUNTERCLOCKWISE}

signal full_circle(bonus : int)

@onready var ResetTimer = get_node("ResetTimer")

var total_boost_bonus : int = 0
var checkpoints_hit : int = 0
var boost_multiplier : int = 1 # could go unused
var state : STATE = STATE.INACTIVE
var previous_checkpoint : RangeObject


func _ready() -> void:
	position = get_viewport().size / 2
	ResetTimer.connect("timeout", reset)
	for range_obj in get_children():
		if range_obj is RangeObject:
			range_obj.connect("checkpoint_hit", checkpoint_hit)

func reset() -> void:
	print("resetting checkpoints")
	checkpoints_hit = 0
	total_boost_bonus = 0
	#previous_checkpoint = null
	state = STATE.INACTIVE
	ResetTimer.paused = true
	for range_obj in get_children():
		if range_obj is RangeObject:
			range_obj.reset()

func checkpoint_hit(range_obj : RangeObject) -> void:
	# on mouse exit
	if previous_checkpoint:
		previous_checkpoint.boost_given = false
	print(state)
	if state == STATE.INACTIVE and previous_checkpoint != null:
		if previous_checkpoint == range_obj.clockwise_neighbor:
			state = STATE.COUNTERCLOCKWISE
		elif previous_checkpoint == range_obj.counterclockwise_neighbor:
			state = STATE.CLOCKWISE
		
	elif state == STATE.CLOCKWISE:
		if previous_checkpoint == range_obj.counterclockwise_neighbor:
			pass
		else:
			print("spin broken at " + str(range_obj))
			reset()
			range_obj.boost_given = false
			previous_checkpoint = null
			return
	elif state == STATE.COUNTERCLOCKWISE:
		if previous_checkpoint == range_obj.clockwise_neighbor:
			pass
		else:
			print("spin broken at " + str(range_obj))
			reset()
			range_obj.boost_given = false
			previous_checkpoint = null
			return
	checkpoints_hit += 1
	previous_checkpoint = range_obj
	total_boost_bonus += range_obj.boost_bonus
	print("Checkpoints hit: " + str(checkpoints_hit))
	ResetTimer.paused = false
	ResetTimer.start()
	#print(state)
	if checkpoints_hit == 4:
		#reward boost
		print("Total boost: " + str(total_boost_bonus))
		full_circle.emit(total_boost_bonus)
		reset()
	# if state is INACTIVE, AND checkpoints_hit > 0, grant bonus and set direction b
