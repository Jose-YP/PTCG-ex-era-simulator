extends Control

@export var comparators: Array[Comparator]

func _ready() -> void:
	SignalBus.finished_coinflip.connect(finished_results)
	
	var buttons: Array[Node] = get_tree().get_nodes_in_group("Button")
	for i in range(buttons.size()):
		buttons[i].pressed.connect(use_comparator.bind(i))

func use_comparator(index: int):
	Globals.fundies.record_source_target(true,
	 [Globals.full_ui.get_poke_slots(Consts.SIDES.ATTACKING, Consts.SLOTS.ACTIVE)[0]],
	 [Globals.full_ui.get_poke_slots(Consts.SIDES.DEFENDING, Consts.SLOTS.ACTIVE)[0]])
	
	print("FINAL RESULT: ", comparators[index].start_comparision())
	
	Globals.fundies.remove_top_source_target()
	if not comparators[index].has_coinflip():
		finished_results()


func finished_results():
	print_rich("[b][wave amp=50.0 freq=5.0 connected=1]YIPPEE!!!!")
