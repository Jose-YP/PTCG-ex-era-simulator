@icon("res://Art/ProjectSpecific/drag-and-drop.png")
extends Node
class_name  On_Slot_Actions

@export var poke_slots: Array[PokeSlot]
@onready var fundies: Fundies = $".."

signal chosen

var play_functions: Array[Callable] = [play_basic_pokemon, play_evolution, 
play_place_stadium, play_attatch_tool, play_attatch_tm, play_fossil, 
play_energy, play_trainer]

func _ready() -> void:
	SignalBus.connect_to(play_functions)

func determine_play() -> void:
	pass

#--------------------------------------
#region MANAGING CARD PLAY
#For basic mons & fossils
#region ADD POKEMON
func play_basic_pokemon(card: Base_Card):
	#Insert the card onto an active spot if there is one
	for slot in fundies.active_slots:
		if not slot.current_card:
			fundies.hide_list()
			slot.current_card = card
			slot.refresh()
			#Remove the card from hand
			fundies.player_resources.play_card(card)
			return
	
	starting_choice("Bench", "Where will pokemon be benched", card, func(slot: PokeSlot): return not slot.current_card)
	await chosen
	
	#Otherwise tell sLot UI actions to prompt the user into placing the bench mon
	print("Active slots full")
	card.print_info()

func play_fossil(card: Base_Card):
	for slot in fundies.active_slots:
		if not slot.current_card:
			fundies.hide_list()
			slot.current_card = card
			slot.refresh()
			#Remove the card from hand
			fundies.player_resources.play_card(card)
			return
	
	starting_choice("Bench", "Where will pokemon be benched", card, func(slot: PokeSlot): return not slot.current_card)
	await chosen
	card.print_info()

#For evolutions on pokemon and fossils
func play_evolution(card: Base_Card):
	starting_choice("Energy", str("Evolve ", card.name, " from which Pokemon")\
	, card, can_evolve_into)
	
	await chosen
	print("Attatch ", card.name)
	card.print_info()
#endregion
#For energy cards
func play_energy(card: Base_Card):
	starting_choice("Energy", str("Attatch ", card.name, " to which Pokemon")\
	, card, energy_boolean)
	
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
		
	
	if card.trainer_properties.always_effect:
		pass

#For tools
func play_attatch_tool(card: Base_Card):
	starting_choice("Energy", str("Attatch ", card.name, " to which Pokemon")\
	, card, tool_boolean)
	
	await chosen
	print("Attatch ", card.name)
	card.print_info()

func play_attatch_tm(card: Base_Card):
	starting_choice("Energy", str("Attatch ", card.name, " to which Pokemon")\
	, card, tool_boolean)
	
	await chosen
	print("Attatch ", card.name)
	card.print_info()

#For stadiums
func play_place_stadium(card: Base_Card):
	pass
#endregion

func starting_choice(choice_type: String, instruction: String, card: Base_Card, bool_fun: Callable):
	fundies.hide_list()
	fundies.slot_ui_actions.get_allowed_slots(bool_fun)
	
	if fundies.slot_ui_actions.allowed_slots:
		print(fundies.slot_ui_actions.allowed_slots)
		fundies.slot_ui_actions.set_doing(choice_type)
		fundies.slot_ui_actions.get_choice(card, instruction)
		await fundies.slot_ui_actions.chosen
		
		chosen.emit()
		fundies.player_resources.play_card(card)
		fundies.slot_ui_actions.set_doing("Nothing")
		fundies.slot_ui_actions.color_tween(Color.TRANSPARENT)
	
	print("Attatch ", card.name)


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

func search_effect(_search: Search):
	pass

#endregion
#--------------------------------------

#Make these functions now so they can be expanded for edge cases later
#--------------------------------------
#region BOOLEAN FUNCTIONS
func can_evolve_into(slot: PokeSlot, evolution: Base_Card) -> bool:
	return slot.current_card.name == evolution.pokemon_properties.evolves_from

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
