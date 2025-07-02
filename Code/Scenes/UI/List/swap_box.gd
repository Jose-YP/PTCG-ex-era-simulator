@icon("res://Art/ProjectSpecific/swap.png")
extends Control
class_name SwapBox

#--------------------------------------
#region VARIABLES
@export var side: CardSideUI
@export var singles: bool = true

@onready var playing_list: PlayingList = %PlayingList
@onready var slot_list: SlotList = %SlotList
@onready var header: HBoxContainer = %Header
@onready var footer: PanelContainer = %Footer
@onready var energy_types: EnergyCollection = %EnergyTypes
@onready var blank: Control = %Blank

enum STEP {GIVER, ENERGY, RECIECVER}

signal finished

const stack = Constants.STACKS.PLAY
const stack_act = Constants.STACK_ACT.ENSWAP

var swap_rules: EnMov
var swaps_made: int = 0
var giver: PokeSlotButton
var reciever: PokeSlotButton
var energy_given: Array[PlayingButton]
#endregion
#--------------------------------------

#--------------------------------------
#region INITALIZATION
func _ready() -> void:
	slot_list.side = side
	slot_list.singles = singles
	slot_list.setup()
	
	for button in slot_list.slots:
		button.pressed.connect(handle_pressed_slot.bind(button))
	
	if swap_rules == null:
		var default_effect: EffectCall = load("res://Resources/Components/Effects/EnergyMovement/AtkSwapBasic.tres")
		swap_rules = default_effect.energy_movement
	
	setup()
	header.setup("SWAP BOX")
	footer.setup(str("PRESS ESC TO UNDO \t SWAPS MADE: ", swaps_made, "/",swap_rules.action_ammount))

func setup():
	pass
#endregion
#--------------------------------------

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Back"):
		if reciever != null:
			reciever = null
		elif energy_given.size() > 0:
			energy_given.pop_back().flat = false
			allowed_more()
			display_current_swap()
		elif giver != null:
			giver = null
			playing_list.reset_items()

#--------------------------------------
#region GIVE/RECIEVE
func handle_pressed_slot(slot_button: PokeSlotButton):
	if giver == null:
		get_swappable(slot_button)
	elif giver != slot_button:
		reciever = slot_button
		%Swap.disabled = false
		%Swap.text = str("Swap ",energy_given.size(), " to ", slot_button.slot.current_card.name)

func get_swappable(slot_button: PokeSlotButton):
	playing_list.reset_items()
	var energy_dict: Dictionary[Base_Card, bool] = {}
	
	for card in slot_button.slot.energy_cards:
		#Asume true for now, make a function to see if it fails or not later
		energy_dict[card] = swap_rules.energy_allowed(card, false)
		print(card.name, energy_dict[card])
	
	playing_list.list = energy_dict
	playing_list.all_lists = [energy_dict]
	playing_list.set_items()
	for button in playing_list.get_items():
		button.select.connect(select_energy.bind(button))
	
	giver = slot_button
	
	update_info(str("Choose cards to swap from ", slot_button.slot.current_card.name,
	 "\n", 0,"/",swap_rules.energy_ammount))
#endregion
#--------------------------------------

#--------------------------------------
#region ENERGY SELECTION
func select_energy(button: PlayingButton):
	button.flat = not button.flat
	if button.flat:
		energy_given.append(button)
		print("ADDING: ", button.card.name, button.card)
	else:
		energy_given.erase(button)
		print("REMOVING: ", button.card.name, button.card)
	
	display_current_swap()
	
	print(energy_given)
	allowed_more()
	update_info(str(energy_given.size() ,"/",swap_rules.energy_ammount,
	 "\n", "Choose cards to swap from ", giver.slot.current_card.name))

func allowed_more():
	if energy_given.size() == swap_rules.energy_ammount:
		for button in playing_list.get_items():
			if button.flat: continue
			button.disabled = true
		print("DISABLE THE REST")
	else:
		for button in playing_list.get_items():
			button.disabled = not playing_list.list[button.card]
		print("REENABLE THE REST")

func display_current_swap():
	var energy_dict: Dictionary[String, int] = {"Grass": 0, "Fire": 0, "Water": 0,
	 "Lightning": 0, "Psychic":0, "Fighting":0 ,"Darkness":0, "Metal":0,
	 "Colorless":0, "Magma":0, "Aqua":0, "Dark Metal":0, "React": 0, 
	 "FF": 0, "GL": 0, "WP": 0, "Rainbow":0}
	var energy_names: Array[String]
	
	for button in energy_given:
		var energy_name: String = button.card.energy_properties.how_display()
		energy_names.append(energy_name)
		energy_dict[energy_name] += button.card.energy_properties.number
	
	energy_types.display_energy(energy_names, energy_dict)
	if energy_types.visible: blank.hide()
	else: blank.show()

#endregion
#--------------------------------------

func update_info(txt: String):
	%Instructions.clear()
	%Instructions.append_text(txt)

func _on_end_pressed() -> void:
	pass # Replace with function body.

func _on_swap_pressed() -> void:
	pass # Replace with function body.
