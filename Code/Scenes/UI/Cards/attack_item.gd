@icon("res://Art/Energy/48px-Fire-attack.png")
extends MarginContainer

@export var attack: Attack
@export var card_name: String

@onready var final_cost:Array[String] = attack.get_energy_cost()
@onready var energy_icons: Array[Node] = %Types.get_children()
@onready var attackButton: Button = $AttackButton

var slot: PokeSlot

# Called when the node enters the scene tree for the first time.
func _ready():
	set_attack()

func set_attack():
	%Name.clear()
	%Name.append_text(str("[center]",attack.name))
	
	%EffectText.clear()
	if attack.description != "":
		var final_text: String = Convert.reformat(attack.description, card_name)
		%EffectText.append_text(final_text)
		%EffectText.show()
	
	final_cost = attack.get_energy_cost()
	print("Current final Cost: ", final_cost)
	
	for icon in energy_icons:
		icon.hide()
	for i in range(final_cost.size()):
		energy_icons[i].display_type(final_cost[i])
		energy_icons[i].show()
	
	%Damage.clear()
	print(attack.attack_data.initial_main_DMG, attack.attack_data.modifier)
	if attack.attack_data.initial_main_DMG > 0:
		%Damage.append_text(str(attack.attack_data.initial_main_DMG))
		match attack.attack_data.modifier:
			1: %Damage.append_text("+")
			2: %Damage.append_text("x")
			3:
				%Damage.clear()
				%Damage.append_text(str("-",attack.attack_data.initial_main_DMG))

func check_usability():
	var result: bool = attack.condition_allows(slot.applied_condition.turn_cond)\
	and slot.is_attacker() and attack.can_pay(slot)
	
	attackButton.disabled = false if result else true

func make_unusable():
	attackButton.disabled = true

func _on_focus_entered():
	attackButton.grab_focus()

func _on_attack_button_pressed() -> void:
	Globals.full_ui.remove_top_ui()
	SignalBus.attack.emit(slot, attack)
