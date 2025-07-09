extends Control

@export var comparators: Array[Comparator]

@onready var comparison: OptionButton = $PlayAs/Items/Comparison

func _ready() -> void:
	var buttons: Array[Node] = get_tree().get_nodes_in_group("Button")
	for i in range(buttons.size()):
		buttons[i].pressed.connect(use_comparator.bind(i))

func use_comparator(index: int):
	Globals.fundies.record_source_target(true,
	 [Globals.full_ui.get_poke_slots(Constants.SIDES.ATTACKING, Constants.SLOTS.ACTIVE)[0]],
	 [Globals.full_ui.get_poke_slots(Constants.SIDES.DEFENDING, Constants.SLOTS.ACTIVE)[0]])
	
	print("FINAL RESULT: ", comparators[index].start_comparision())
	
	Globals.fundies.remove_top_source_target()
