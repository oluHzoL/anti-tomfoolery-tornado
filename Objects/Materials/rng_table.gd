extends Resource

class_name RNGTable
## A resource that handles the rng for returning a value or attribute.
## Isn't having code from other unfinished Godot projects nice?



var rng = RandomNumberGenerator.new() ## An instance of [RandomNumberGenerator]. The seed gets randomized every time [method random_picker] is called.
var weight_list : Array ## The current list of [member weight_table]'s values, organized in descending order. This can be reset using [method full_reset].
var key_list : Array ## The current list of [member weight_table]'s keys, inheriting the indexes of their weights in [member weight_list]. This can be reset using [method full_reset].
var key_weight_list : Array ## Records the keys and values of [member weight_table] to be ordered by numeric index then sorted.
var total_weight : int = 0 ## The sum of every weight in [member weight_table] taken from [member weight_list].

## Contains default keys and their corresponding weight. Keys must be strings and values must be ints.
@export var rng_weight_table : Dictionary[String, int]
## A duplicate of [member rng_weight_table] that can be changed freely.
## [member weight_table] can be reset to [member rng_weight_table]'s dictionary using [method full_reset].
var weight_table : Dictionary


## Configures the weight list and calculates the total weight of each value in the dictionary.
## This function is called whenever random generation is started (to prevent total weight from increasing more than intended).
## This function can also be called whenever a key's weight is changed. [br][br]
## [b][method weight_list_config] will always be called before [method random_picker].[/b]
func weight_list_config():
	total_weight = 0
	key_weight_list.clear()
	
	#print("wt Values: ", weight_table.values())
	#print("wt Keys: ", weight_table.keys())
	
	weight_list = weight_table.values().duplicate(true)
	key_list = weight_table.keys().duplicate(true)
	
	for i in weight_table.size():
		key_weight_list.append([key_list[i], weight_list[i]])
	
	#print("kw list: ", key_weight_list)
	key_weight_list.sort_custom(sort_table_arrays)
	weight_list.sort() # sorts the weight list in ascending order
	weight_list.reverse() # then reverses it into a descending order
	#print("kw list sorted: ", key_weight_list)
	
	for i in weight_list.size():
		total_weight += weight_list[i]
	#print("Total weight is ", total_weight)
	#print("Weight list: ", weight_table.values())
	#print("Sorted weight list: ", weight_list)

## Custom sorting algorithm meant to be called within [method weight_list_config]
## This function compares the values within the 2nd index (1) of both [param a] and [param b]
## and sorts the arrays in descending order. [br] [br]
## This algorithm was made so that multiple keys with the same value can be discerned, since [Dictionary] doesn't use numeric indexes.
func sort_table_arrays(a : Array, b : Array):
	if a[1] > b[1]:
		return true
	return false

## Resets [member weight_table] to its unmodified values using [member original_table].
## This does NOT account for the order of the keys being changed.
## [b] [method reset_weight_table] must be called before using [method return_random_key].
func reset_weight_table():
	# NOTE: original_table has NO value as of right now, this is not intended
	weight_table = rng_weight_table.duplicate(true)
		# Ideally, the order is not a problem, but it's something to note

## Resets [member weight_list] and [member key_list] to its defaults before recalculating total weight. [br][br]
## [b]It is important to call [method full_reset] as frequently as necessary to prevent
## unintended values within an instance of [RNGTable] upon its repeated usage.
## This function should also be called at the end of every generation. [/b]
func full_reset():
	reset_weight_table()
	weight_list_config()

## Adjusts the weight of a key, then automatically calls [method weight_list_config].
func weight_adjust(key, value : int):
	weight_table[key] = value
	weight_list_config()

## Uses the generated RNG seed to return a key from a chosen value while factoring weight.
func random_picker() -> int:
	rng.randomize()
	weight_list_config()
	
	var chosen_value = rng.randi_range(0, total_weight)
	
	for n in weight_list.size():
		#print("chosen_value is currently: ", chosen_value)
		#print("n is currently: ", n)
		if chosen_value <= weight_list[n]:
			return n # n is the chosen index of the sorted weight_list.
		chosen_value -= weight_list[n]
	print("RNG Error") # if it gets here my code is wrong, there should probably be a more
	return -1 # proper error report here

## Returns a random key from [member weight_table] by calling [method random_picker].
func return_random_key():
	reset_weight_table()
	var value : int = random_picker()
	var returned_key = key_weight_list[value][0]
	return returned_key


## Return odds of a returning a certain key specified with [param target] based on its weight.
func get_string_odds(target) -> float: 
	weight_list_config()
	var t : float = weight_table[target] * 1.0
	return (t / total_weight)

## Return odds of a returning a certain key if it had a weight of [param target] with the same total weight.
## This does not add to the total weight, however.
func get_weight_odds(target : int) -> float:
	weight_list_config()
	var t : float = target * 1.0
	return (t / total_weight)

## Return a list of odds of a returning every key based on their corresponding weight.
func get_odds_list() -> Array: 
	var odds_list = []
	weight_list_config()
	
	for i in weight_list.size():
		odds_list.append(get_weight_odds(weight_list[i]))
	return odds_list
