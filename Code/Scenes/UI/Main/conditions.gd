extends VBoxContainer
class_name ConditionDisplay

@export var bench: bool = false
@export var poison_gradient: Gradient
@export var burn_gradient: Gradient
@export var condition: Condition:
	set(v):
		condition = v
		if readied:
			display_condition()

@onready var condition_images: Array[Control] = [%Poison, %Burn,
 %TurnConditions, %Imprison, %Shockwave]

var readied: bool = false

func _ready() -> void:
	display_condition()
	readied = true

func display_condition():
	if condition.poison != 0:
		%Poison.show()
		color_poison(condition.poison - 1)
		
	else: %Poison.hide()
	
	if condition.burn != 0:
		%Burn.show()
		color_burn(condition.burn - 1)
	else: %Burn.hide()
	
	if condition.mutually_exclusive_conditions != 0:
		%TurnConditions.show()
		%TurnConditions.current_tab = condition.mutually_exclusive_conditions
	else: %TurnConditions.hide()
	
	if condition.imprision:
		%Imprison.show()
	else: %Imprison.hide()
	
	if condition.shockwave:
		%Shockwave.show()
	else: %Shockwave.hide()

func color_poison(value: int):
	%Poison.modulate = poison_gradient.get_color(value)

func color_burn(value: int):
	%Burn.modulate = burn_gradient.get_color(value)

func check_bench():
	if bench:
		printerr("Should not have this condition")

func _on_h_slider_value_changed(value: float) -> void:
	color_poison(int(value))

func _on_h_slider_2_value_changed(value: float) -> void:
	color_burn(int(value))
