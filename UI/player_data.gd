extends Node
class_name PlayerData

var time_taken : float = 0

func calculate_time_taken(time : Timer):
	time_taken = time.get_time_left()

func time_to_string() -> String:
	var minutes: int = floori(time_taken / 60.0)
	var seconds: int = int(time_taken) % 60
	return "%02d:%02d" % [minutes, seconds] # like python wow
