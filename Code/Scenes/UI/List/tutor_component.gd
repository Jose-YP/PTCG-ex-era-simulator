extends Node
#This component hold all the code that manages it's relation with
#the tutor box, which means it can transfer cards, and switch dicts
@export var offset: float = 50

@onready var par: PlayingList = $".."

var tutor: Tutor_Box
var search_dict: Dictionary [Identifier, Dictionary]
var allowed_dict: Dictionary[Dictionary, bool]
var readied: bool = false

func setup_tutor(search: Search):
	if not (par.stack_act == Constants.STACK_ACT.TUTOR or par.stack_act == Constants.STACK_ACT.DISCARD):
		printerr("Why is setup tutor being called when there's no tutor on right now?")
		return
	
	#This will help the tutor list enable and disable the necessary cards
	for i in range(par.all_lists.size()):
		search_dict[search.of_this[i]] = par.all_lists[i]
		allowed_dict[par.all_lists[i]] = true
	
	tutor = par.tutor_box.instantiate()
	tutor.search = search
	tutor.position.x = par.size.x + offset
	tutor.connected_list = par
	par.add_sibling(tutor)
	tutor.set_up_tutor()
	tutor.connect("no_more_adding", disable_list)
	readied = true

func list_allowed(card: Base_Card) -> bool:
	var result: bool = false
	for list in par.all_lists:
		result = result or (list[card] and allowed_dict[list])
	return result

func disable_list(id: Identifier):
	allowed_dict[search_dict[id]] = false
	par.refresh_allowance()
	print(search_dict[id])

func enable_list(id: Identifier):
	allowed_dict[search_dict[id]] = true
	par.refresh_allowance()
