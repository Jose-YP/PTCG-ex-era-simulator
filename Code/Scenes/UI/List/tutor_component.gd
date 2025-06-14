extends Node
#This component hold all the code that manages it's relation with
#the tutor box, which means it can transfer cards, and switch dicts
@export var offset: float = 50

@onready var par: PlayingList = $".."

var tutor: Tutor_Box
var search_dict: Dictionary [Identifier, Dictionary]

func setup_tutor(search: Search):
	if not (par.stack_act == Constants.STACK_ACT.TUTOR or par.stack_act == Constants.STACK_ACT.DISCARD):
		printerr("Why is setup tutor being called when there's no tutor on right now?")
		return
	
	#This will help the tutor list enable and disable the necessary cards
	for i in range(par.all_lists.size()):
		search_dict[search.of_this[i]] = par.all_lists[i]
	
	tutor = par.tutor_box.instantiate()
	tutor.search = search
	tutor.position.x = par.size.x + offset
	par.add_sibling(tutor)
	tutor.set_up_tutor()
	tutor.connect("no_more_adding", disable_list)

func disable_list(id: Identifier):
	print(search_dict[id])
	

func enable_list(id: Identifier):
	pass
