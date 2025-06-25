@icon("res://Art/ProjectSpecific/drag-and-drop.png")
extends Node
class_name CardPlayer

@onready var fundies: Fundies = $".."

signal chosen

var play_functions: Array[Callable] = [play_basic_pokemon, play_evolution, 
play_place_stadium, play_attatch_tool, play_attatch_tm, play_fossil, 
play_energy, play_trainer]

func _ready() -> void:
	SignalBus.connect_to(play_functions)

func determine_play(card: Base_Card, placement: Placement = null) -> void:
	var card_type: int = Conversions.get_card_flags(card)
	#Play fossils, basics and evolutions onto the bench
	if card_type & 1 != 0 or (card_type & 2 != 0 and placement and not placement.evolve):
		play_basic_pokemon(card)
	elif card_type & 2 != 0 and placement and placement.evolve:
		play_evolution(card, placement)
	#play stadiums onto the stadium slot
	elif card_type & 32 != 0 :
		play_place_stadium(card)
	elif card_type & 256 != 0:
		play_fossil(card)
	#play energy onto any pokemon defined by placement
	elif card_type & 512 != 0:
		play_energy(card, placement)
	
	#play trainers
	else:
		play_trainer(card)

#--------------------------------------
#region MANAGING CARD PLAY
#For basic mons & fossils
#region ADD POKEMON
func play_basic_pokemon(card: Base_Card):
	#Insert the card onto an active spot if there is one
	for slot in fundies.active_slots:
		if not slot.current_card:
			fundies.hide_list()
			slot.set_card(card)
			slot.current_card = card
			slot.refresh()
			#Remove the card from hand
			fundies.stack_manager.play_card(card)
			return
	
	starting_choice("Where will pokemon be benched", card, func(slot: PokeSlot): return not slot.current_card)
	await chosen
	
	#Otherwise tell sLot UI actions to prompt the user into placing the bench mon
	print("Active slots full")
	card.print_info()

func play_fossil(card: Base_Card):
	for slot in fundies.active_slots:
		if not slot.current_card:
			fundies.hide_list()
			slot.set_card(card)
			slot.refresh()
			#Remove the card from hand
			fundies.stack_manager.play_card(card)
			return
	
	starting_choice("Where will pokemon be benched", card, func(slot: PokeSlot): return not slot.current_card)
	await chosen
	card.print_info()

#For evolutions on pokemon and fossils
func play_evolution(card: Base_Card, placement: Placement = null):
	var evo_fun: Callable = Globals.make_can_evo_from(card)
	
	if placement == null:
		starting_choice(str("Evolve ", card.name, " from which Pokemon"), card, evo_fun)
	else:
		var place_func = func placement_evo(slot):
			if slot.is_in_slot(Constants.SIDES.SOURCE,placement.slot):
				return evo_fun.call(slot)
			else: return false
		
		starting_choice(str("Evolve ", card.name, " from which Pokemon"), card, place_func)
	
	await chosen
	print("Attatch ", card.name)
	card.print_info()
#endregion
#For energy cards
func play_energy(card: Base_Card, placement:Placement = null):
	if placement == null:
		pass
	else:
		pass
	
	starting_choice(str("Attatch ", card.name, " to which Pokemon"), card, energy_boolean)
	
	await chosen
	print("Attatch ", card.name)
	card.print_info()

#region TRAINERS
func play_trainer(card: Base_Card):
	var trainer: Trainer = card.trainer_properties
	if trainer.prompt:
		print("This card has a prompt")
	
	if trainer.asks:
		#Determine a way to check asks and prompts easily
		
		#if trainer.asks.check_ask():
			#trainer.success_effect.play_effect(fundies)
		#else:
			#trainer.fail_effect.play_effect(fundies)
		
		print("This card has an ask")
	
	if trainer.always_effect:
		trainer.always_effect.play_effect(fundies, [], [])

#For tools
func play_attatch_tool(card: Base_Card):
	starting_choice(str("Attatch ", card.name, " to which Pokemon")\
	, card, tool_boolean)
	
	await chosen
	print("Attatch ", card.name)
	card.print_info()

func play_attatch_tm(card: Base_Card):
	starting_choice(str("Attatch ", card.name, " to which Pokemon")\
	, card, tool_boolean)
	
	await chosen
	print("Attatch ", card.name)
	card.print_info()

#For stadiums
func play_place_stadium(card: Base_Card):
	pass
#endregion

func starting_choice(instruction: String, card: Base_Card, bool_fun: Callable):
	fundies.hide_list()
	fundies.ui_actions.get_allowed_slots(bool_fun)
	
	if fundies.ui_actions.allowed_slots:
		fundies.ui_actions.get_choice(card, instruction)
		await fundies.ui_actions.chosen
		
		chosen.emit()
		fundies.stack_manager.play_card(card)
		#fundies.ui_actions.set_doing("Nothing")
		fundies.ui_actions.color_tween(Color.TRANSPARENT)
	
	print("Attatch ", card.name)

func manage_tutored(tutored_cards: Array[Base_Card], placement: Placement):
	for card in tutored_cards:
		determine_play(card, placement)

#endregion
#--------------------------------------

#--------------------------------------
#region DETERMINING EFFECTS
func scope_effect():
	pass

#endregion
#--------------------------------------

#--------------------------------------
#region EFFECT TYPES
func condition_effect(_condition: Condition):
	pass

func draw_effect(_card_draw: Counter):
	pass

func buff_effect(_buff: Buff):
	pass

func card_disrupt_effect(_card_dis: CardDisrupt):
	pass

func disable_effect(_disable: Disable):
	pass

func energy_mov_effect(_en_mov: EnMov):
	pass

func dmg_manip_effect(_dmg_manip: DamageManip):
	pass

#endregion
#--------------------------------------

#Make these functions now so they can be expanded for edge cases later
#--------------------------------------
#region BOOLEAN FUNCTIONS
func energy_boolean(slot: PokeSlot) -> bool:
	return slot.current_card != null

func tool_boolean(slot: PokeSlot) -> bool:
	if slot.current_card:
		return slot.tool_card == null
	
	else: return false

func tm_boolean(slot: PokeSlot) -> bool:
	if slot.current_card:
		return true
	
	else: return false

#endregion
#--------------------------------------
