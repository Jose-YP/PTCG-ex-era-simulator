@icon("res://Art/ProjectSpecific/drag-and-drop.png")
extends Node
class_name  On_Slot_Actions

@export var poke_slots: Array[PokeSlot]
@onready var fundies: Fundies = $".."

var play_functions: Array[Callable] = [play_basic_pokemon, play_evolution, 
play_place_stadium, play_attatch_tool, play_attatch_tm, play_fossil, 
play_energy, play_on_nothing]

func _ready() -> void:
	SignalBus.connect_to(play_functions)

func determine_play() -> void:
	pass

#--------------------------------------
#region MANAGING CARD PLAY
#For basic mons & fossils
func play_basic_pokemon(card: Base_Card):
	#Remove the card from hand
	fundies.player_resources.play_card(card)
	
	#Insert the card onto an active spot if there is one
	for slot in fundies.active_slots:
		if not slot.current_card:
			slot.current_card = card
			slot.refresh()
			return
	
	fundies.slot_ui_actions.get_allowed_slots(func(slot: PokeSlot): return not slot.current_card)
	if fundies.slot_ui_actions.allowed_slots:
		print(fundies.slot_ui_actions.allowed_slots)
		fundies.slot_ui_actions.set_doing("Bench")
		fundies.slot_ui_actions.get_choice(card)
		await fundies.slot_ui_actions.chosen
		fundies.slot_ui_actions.set_doing("Nothing")
		fundies.slot_ui_actions.color_tween(Color.TRANSPARENT)
		
	
	#Otherwise tell sLot UI actions to prompt the user into placing the bench mon
	print("Active slots full")
	card.print_info()

#For items, supporters, rsm
func play_on_nothing():
	pass

#For evolutions on pokemon and fossils
func play_evolution():
	pass

#For energy cards
func play_energy():
	pass

#For tools
func play_attatch_tool():
	pass

func play_attatch_tm():
	pass

func play_fossil():
	pass

#For stadiums
func play_place_stadium():
	pass
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
