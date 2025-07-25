extends Control

@export var counters: Array[IndvCounter]

@onready var comparison: OptionButton = $PlayAs/Items/Comparison

func _ready() -> void:
	var buttons: Array[Node] = get_tree().get_nodes_in_group("Button")
	for i in range(buttons.size()):
		buttons[i].pressed.connect(use_counter.bind(i))

func use_counter(index: int):
	Globals.fundies.record_source_target(true,
	 Globals.full_ui.get_poke_slots(Consts.SIDES.ATTACKING, Consts.SLOTS.ACTIVE),
	 Globals.full_ui.get_poke_slots(Consts.SIDES.DEFENDING, Consts.SLOTS.ACTIVE))
	
	print("FINAL RESULT: ", counters[index].evaluate())
	
	Globals.fundies.remove_top_source_target()
