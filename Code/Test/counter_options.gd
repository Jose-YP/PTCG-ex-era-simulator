extends Control

@export var counters: Array[IndvCounter]

@onready var comparison: OptionButton = $PlayAs/Items/Comparison

var full_count: Counter = Counter.new()

func _ready() -> void:
	var buttons: Array[Node] = get_tree().get_nodes_in_group("Button")
	for i in range(buttons.size()):
		buttons[i].pressed.connect(use_counter.bind(i))

func use_counter(index: int):
	print(comparison.get_selected_id())
	print(counters[index])
	print("FINAL RESULT: ", counters[index].evaluate())
