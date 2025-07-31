@icon("res://Art/Energy/48px-Water-attack.png")
extends MarginContainer

@export var ability: Ability
@export var slot: PokeSlot

@onready var ability_button: Button = $AbilityButton

# Called when the node enters the scene tree for the first time.
func _ready():
	%Name.clear()
	%Name.append_text("[center]")
	%Name.push_color(Color(0.895, 0.583, 0.625))
	%Name.append_text(ability.name)
	
	%EffectText.clear()
	if ability.description != "":
		var final_text: String = Convert.reformat(ability.description, slot.get_card_name())
		%EffectText.append_text(final_text)
		%EffectText.show()
	
	if ability.category == "Body":
		ability_button.set_theme_type_variation("BodyButton")
	
	check_pressable()

func check_pressable():
	if ability.occurance:
		ability_button.disabled = true
		return
	
	match ability.how_often:
		"Passive":
			ability_button.disabled = true
		"Once Per Mon":
			ability_button.disabled = slot.power_exhaust or not check_allowed()
		"Once Per Turn":
			ability_button.disabled = Globals.fundies.used_ability(ability.name) or not check_allowed()
		"Infinite":
			ability_button.disabled = check_allowed()

func check_allowed():
	if ability.prompt:
		return ability.prompt.check_prompt()

func _on_focus_entered():
	ability_button.grab_focus()
