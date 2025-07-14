@icon("res://Art/Energy/35px-Rainbow-attack.png")
extends Control

@onready var button: Button = %Button
@onready var types: Control = %Types

var num: int = 0

func _ready() -> void:
	add_type("Rainbow", 1)
	colored_shadow()

func add_type(type: String, ammount: int = 1):
	num = ammount
	types.display_type(type)
	
	number_text()

func remove_type():
	num -= 1
	$Number.clear()
	$Number.append_text(str(num))
	
	number_text()

func number_text():
	%Number.clear()
	%Number.append_text(str("+99" if num > 99 else num))
	
	if num >= 1: show()
	elif num > 1: %Number.show()
	else: $Number.hide()

func colored_shadow() -> void:
	var hover: StyleBoxFlat = button.get_theme_stylebox("hover")
	var focus: StyleBoxFlat = button.get_theme_stylebox("focus")
	var pressed: StyleBoxFlat = button.get_theme_stylebox("pressed")
	var color: Color = Consts.energy_colors[types.get_type_index()]
	
	hover.shadow_color = Color(color, .25)
	hover.border_color *= color
	focus.shadow_color = Color(color, .25)
	focus.border_color *= color
	focus.bg_color  *= color
	pressed.shadow_color = Color(color, .25)
	pressed.border_color *= color
	pressed.bg_color *= color

func _on_button_pressed() -> void:
	pass # Replace with function body.
