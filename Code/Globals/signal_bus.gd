extends Node

#STACK SIGNALS
@warning_ignore("unused_signal")
signal show_list(whose: String, list: Constants.STACKS, act: Constants.STACK_ACT)
@warning_ignore("unused_signal")
signal show_energy_attatched(origin: PokeSlot)
@warning_ignore("unused_signal")
signal swap_card_location(card: Array[Base_Card], placement: Placement, from: Constants.STACKS)
@warning_ignore("unused_signal")
signal reorder_cards(card: Array[Base_Card], placement: Placement,)
@warning_ignore("unused_signal")
signal start_tutor(search: Search)
@warning_ignore("unused_signal")
signal tutor_card(card: Base_Card)
@warning_ignore("unused_signal")
signal cancel_tutor(button: Button)
#CARD DISPLAY SIGNALS
@warning_ignore("unused_signal")
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
@warning_ignore("unused_signal")
signal get_candidate(pokeSlot: PokeSlot)
@warning_ignore("unused_signal")
signal finished_coinflip()

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
