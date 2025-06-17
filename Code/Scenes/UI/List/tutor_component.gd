extends Node
#This component hold all the code that manages it's relation with
#the tutor box, which means it can transfer cards, and switch dicts
@export var offset: float = 50

@onready var par: PlayingList = $".."

var tutor: Tutor_Box
var search_dict: Dictionary [Identifier, Dictionary]
var allowed_dict: Dictionary[Dictionary, bool]
var choices_left: Dictionary[Dictionary, int]
var readied: bool = false

func setup_tutor(search: Search):
	if not (par.stack_act == Constants.STACK_ACT.TUTOR or par.stack_act == Constants.STACK_ACT.DISCARD):
		printerr("Why is setup tutor being called when there's no tutor on right now?")
		return
	
	#This will help the tutor list enable and disable the necessary cards
	for i in range(par.all_lists.size()):
		var num_allowed: int = 0
		for item in par.all_lists[i]:
			if par.all_lists[i][item]:
				num_allowed += 1
		search_dict[search.of_this[i]] = par.all_lists[i]
		allowed_dict[par.all_lists[i]] = true
		choices_left[par.all_lists[i]] = num_allowed
	
	tutor = par.tutor_box.instantiate()
	tutor.search = search
	tutor.position.x = par.size.x + offset
	tutor.connected_list = par
	par.add_sibling(tutor)
	tutor.set_up_tutor()
	#tutor.connect("no_more_adding", disable_list)
	tutor.connect("check_requirements", check_lists)
	
	readied = true

func list_allowed(card: Base_Card) -> bool:
	var result: bool = false
	for list in par.all_lists:
		result = result or (list[card] and allowed_dict[list])
	return result


func check_lists(id: Identifier, allowed: bool, choices_made: int):
	print(choices_made, choices_left[search_dict[id]])
	print(allowed, choices_made < choices_left[search_dict[id]])
	allowed_dict[search_dict[id]] = allowed and choices_made < choices_left[search_dict[id]]
	par.refresh_allowance()
	if choices_made < choices_left[search_dict[id]]:
		tutor.nothing_left()
	
	for dict in allowed_dict:
		#probably not necessary like this but I might break it if I change
		if allowed_dict[dict] and search_dict[id] != dict:
			tutor.nothing_left()
			return
		elif allowed_dict[dict]:
			return
	
	tutor.nothing_left()
