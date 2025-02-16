extends MarginContainer

@export var attack: Attack

@onready var final_cost:Array[String] = attack.get_energy_cost()
@onready var energy_icons: Array[Node] = %Types.get_children()
@onready var attackButton: Button = $AttackButton

# Called when the node enters the scene tree for the first time.
func _ready():
	%Name.clear()
	%Name.append_text(str("[center]",attack.name))
	
	%EffectText.clear()
	if attack.description != "":
		%EffectText.append_text(attack.description)
		%EffectText.show()
	
	print(final_cost)
	
	for i in range(final_cost.size()):
		energy_icons[i].display_type(final_cost[i])
		energy_icons[i].show()
	
	%Damage.clear()
	print(attack.initial_main_DMG, attack.modifier)
	if attack.initial_main_DMG > 0:
		%Damage.append_text(str(attack.initial_main_DMG))
		match attack.modifier:
			1: %Damage.append_text("+")
			2: %Damage.append_text("x")
			3:
				%Damage.clear()
				%Damage.append_text(str("-",attack.initial_main_DMG))
	
	$AttackButton/Marker2D.position.y = size.y/2

func _on_focus_entered():
	attackButton.grab_focus()
