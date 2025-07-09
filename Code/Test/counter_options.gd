extends Control

@export var counters: Array[IndvCounter]

@onready var comparison: OptionButton = $PlayAs/Items/Comparison

var full_count: Counter = Counter.new()

func _ready() -> void:
	var buttons: Array[Node] = get_tree().get_nodes_in_group("Button")
	for i in range(buttons.size()):
		buttons[i].pressed.connect(use_counter.bind(i))

func use_counter(index: int):
	Globals.fundies.record_source_target(true,
	 Globals.full_ui.get_poke_slots(Constants.SIDES.ATTACKING, Constants.SLOTS.ACTIVE),
	 Globals.full_ui.get_poke_slots(Constants.SIDES.DEFENDING, Constants.SLOTS.ACTIVE))
	
	print("FINAL RESULT: ", counters[index].evaluate())
	
	Globals.fundies.remove_top_source_target()
