extends Node

#HAND SIGNALS
signal show_starting(can_select: bool, message: String, looking_at: String, list: Array[Base_Card])
signal show_list(whose_hand: String, hand: Array[Base_Card])
#CARD DISPLAY SIGNALS
signal show_other_card(showing: Base_Card)
signal chosen_slot(showing: PokeSlot)
#signal show_options(button: Button, card: Base_Card)
#PLAY CARD SIGNALS
signal play_basic(card: Base_Card)
signal play_evo(card: Base_Card)
signal play_trainer(card: Base_Card)
signal play_stadium(card: Base_Card)
signal play_tool(card: Base_Card)
signal play_tm(card: Base_Card)
signal play_fossil(card: Base_Card)
signal play_energy(card: Base_Card)
#EFFECT SIGNALS

func call_action(action: int, card: Base_Card) -> void:
	match action:
		0:
			play_basic.emit(card)
		1:
			play_evo.emit(card)
		4:
			play_stadium.emit(card)
		5:
			play_tool.emit(card)
		6:
			play_tm.emit(card)
		7:
			play_fossil.emit(card)
		8:
			play_basic.emit(card)
		9:
			play_energy.emit(card)
		_:
			play_trainer.emit(card)
	print("PLAY AS ", Constants.allowed_list_flags[action])

func connect_to(functions: Array[Callable]) -> void:
	var signals: Array[Signal] = [play_basic, play_evo, play_stadium,
	 play_tool, play_tm, play_fossil, play_energy, play_trainer]
	
	for i in range(functions.size()):
		print(functions[i])
		signals[i].connect(functions[i])
