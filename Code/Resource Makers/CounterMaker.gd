extends Resource
class_name Counter

@export var coin_flip_num: CoinFlip

@export_enum("Energy Attacked", "Energy Excess", "Constant") var for_what
@export var cap: int = 0

var results: Dictionary = {"Heads" : 0, "Tails": 0}

func activate_CF() -> Dictionary:
	#Reset before doing this again
	results = {"Heads" : 0, "Tails": 0}
	
	#For until flip until there's a tails
	if coin_flip_num.until:
		var tails: bool = false
		while not tails:
			single_flip()
			if results["Tails"] > 0:
				tails = true
	#For num, flip as many times as stated
	else:
		var times: int = coin_flip_num.const_flip_times
		
		if coin_flip_num.varying_flip_times != 0:
			print("Work on this")
		
		for i in coin_flip_num.times:
			single_flip()
	
	return results

func single_flip():
	var flip: int = randi_range(0,1)
	if flip: results["Heads"] += 1
	else: results["Tails"] += 1
