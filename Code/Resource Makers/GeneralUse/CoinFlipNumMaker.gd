extends Resource
class_name CoinFlip

##Count number of heads or tails?
@export var heads: bool = true
##If this is present then the counter will determine how many coinflips should happen
@export var varying_flip_times: IndvCounter
##If this is true the con will flip until tails and return the total heads
@export var until: bool = false
##Otherwise use the constant number defined here
@export var const_flip_times: int = 1

#@export var effect_array: Dictionary{int: Effect}

var results: Dictionary = {"Heads" : 0, "Tails": 0}
var prev: int

func get_num() -> int:
	if varying_flip_times:
		return varying_flip_times.evaluate()
	else:
		return const_flip_times

func activate_CF() -> Dictionary[String, int]:
	#Reset before doing this again
	results = {"Heads" : 0, "Tails": 0}
	
	#For until flip until there's a tails
	if until:
		var tails: bool = false
		while not tails:
			#Safeguard to prevent infinite flips
			if Globals.coin_rules == Constants.COIN_RULES.HEADS:
				if results["Heads"] > 10: return results
			
			single_flip()
			if results["Tails"] > 0:
				tails = true
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

func get_flip_array(dict: Dictionary) -> Array[bool]:
	var final: Array[bool]
	for result in dict:
		for i in range(dict[result]):
			final.append(result == "Heads")
	
	return final

func single_flip() -> void:
	var flip: int
	match Globals.coin_rules:
		Constants.COIN_RULES.REG:
			flip = randi_range(0,1)
		Constants.COIN_RULES.HEADS:
			flip = 1
		Constants.COIN_RULES.TAILS:
			flip = 0
		Constants.COIN_RULES.ALTERNATE:
			if prev: flip = 0
			else: flip = 1
	
	if flip: results["Heads"] += 1
	else: results["Tails"] += 1
	prev = flip
