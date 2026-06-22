extends Attack

# usually is a melee attack of some kind
# but is generally an attack that relies on an AnimationPlayer
# note that these kinds of attacks will still be rotated like any projectile 


@export var attack_animation : Animation # in the future, change this to an array that holds any number of these


@onready var AttackPlayer : AnimationPlayer = get_node("AttackPlayer")

func launch_attack():
	super()
	AttackPlayer.play() # play some given animation
