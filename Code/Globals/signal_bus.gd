extends Node

#--------------------------------------
#region SIGNALS
#--------------------------------------
#region STACK SIGNALS
@warning_ignore("unused_signal")
signal show_list(home: bool, list: Consts.STACKS, act: Consts.STACK_ACT)
@warning_ignore("unused_signal")
signal show_energy_attatched(origin: PokeSlot)
@warning_ignore("unused_signal")
signal swap_card_location(card: Array[Base_Card], placement: Placement, from: Consts.STACKS)
@warning_ignore("unused_signal")
signal reorder_cards(card: Array[Base_Card], placement: Placement,)
@warning_ignore("unused_signal")
signal start_tutor(search: Search)
@warning_ignore("unused_signal")
signal tutor_card(card: Base_Card)
@warning_ignore("unused_signal")
signal cancel_tutor(button: Button)
#endregion
#--------------------------------------
@warning_ignore("unused_signal")
signal chosen_slot(showing: PokeSlot)
@warning_ignore("unused_signal")
signal attack(slot: PokeSlot, attack: Attack)
@warning_ignore("unused_signal")
signal force_disapear()
@warning_ignore("unused_signal")
signal end_turn()
#--------------------------------------
#region CARD PLAY SIGNALS
signal play_basic(card: Base_Card)
signal play_evo(card: Base_Card)
signal play_trainer(card: Base_Card)
signal play_stadium(card: Base_Card)
signal play_tool(card: Base_Card)
signal play_tm(card: Base_Card)
signal play_fossil(card: Base_Card)
signal play_energy(card: Base_Card)
#endregion
#--------------------------------------
#--------------------------------------
#region EFFECT SIGNALS
@warning_ignore("unused_signal")
signal get_candidate(pokeSlot: PokeSlot)
@warning_ignore("unused_signal")
signal went_back
@warning_ignore("unused_signal")
signal finished_coinflip()
@warning_ignore("unused_signal")
signal prompt_answered(answer: bool)

signal begin_swap(giver: PokeSlot, reciever: PokeSlot, energy: Array[Base_Card])
#endregion
#--------------------------------------
#endregion
#--------------------------------------

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
		8:
			play_fossil.emit(card)
		9:
			play_energy.emit(card)
		_:
			play_trainer.emit(card)
	print("PLAY AS ", Consts.allowed_list_flags[action])

func connect_to(functions: Array[Callable]) -> void:
	var signals: Array[Signal] = [play_basic, play_evo, play_stadium,
	 play_tool, play_tm, play_fossil, play_energy, play_trainer]
	
	for i in range(functions.size()):
		signals[i].connect(functions[i])
