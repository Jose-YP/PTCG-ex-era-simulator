extends Resource
class_name CoinFlip

##Count number of heads or tails?
@export var heads: bool = true
##If this is present then the counter will determine how many coinflips should happen
@export var varying_flip_times: Counter
##If this is true the con will flip until tails and return the total heads
@export var until: bool = false
##Otherwise use the constant number defined here
@export var const_flip_times: int = 1

#@export var effect_array: Dictionary{int: Effect}

var results: Dictionary = {"Heads" : 0, "Tails": 0}

func activate_CF() -> Dictionary:
	#Reset before doing this again
	results = {"Heads" : 0, "Tails": 0}
	
	#For until flip until there's a tails
	if until:
		var tails: bool = false
		while not tails:
			single_flip()
			if results["Tails"] > 0:
				return results
	#For num, flip as many times as stated
	else:
		var times: int = const_flip_times
		
		if varying_flip_times and varying_flip_times.return_count() != 0:
			print("Work on this")
			times = varying_flip_times.return_count()
		
		for i in times:
			single_flip()
	
	return results

func single_flip():
	var flip: int = randi_range(0,1)
	if flip: results["Heads"] += 1
	else: results["Tails"] += 1
