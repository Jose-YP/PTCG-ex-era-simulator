@icon("res://Art/Energy/48px-Fire-attack.png")
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
		var final_text: String = Conversions.reformat(attack.description)
		%EffectText.append_text(final_text)
		%EffectText.show()
	
	print("Current final Cost: ", final_cost)
	
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

func check_usability(energy_array: Array[String]):
	var count_cost: Array[String] = final_cost
	print("CHECKING USABILITY OF ", attack.name, energy_array)
	print(final_cost, count_cost)
	
	#Check basic energy
	for element in energy_array:
		if count_cost.find(element) != -1:
			count_cost.erase(element)
		match element:
			"Rainbow":
				count_cost.pop_front()
			"Magma":
				print("MAGMA")
			"Aqua":
				print("AQUA")
			"Dark Metal":
				print("DARK METAL")
		#The other energies are colorless or single types
		#Any energy type can remove colorless
		if count_cost.find("Colorless") != -1:
			count_cost.erase("Colorless")
	
	print(count_cost)
	attackButton.disabled = true if count_cost else false

func _on_focus_entered():
	attackButton.grab_focus()


func _on_attack_button_minimum_size_changed():
	print("VDESOUJBNBDVJASIJKDV")


func _on_attack_button_resized():
	print("OH ", size.y)
