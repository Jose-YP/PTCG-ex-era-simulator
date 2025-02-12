extends Control

const energy_cards: Array[String] = ["res://Cards/1 ex Ruby & Saphire/RS104GrassEnergy.tres",
"res://Cards/1 ex Ruby & Saphire/RS108FireEnergy.tres","res://Cards/1 ex Ruby & Saphire/RS106WaterEnergy.tres",
"res://Cards/1 ex Ruby & Saphire/RS109LightningEnergy.tres","res://Cards/1 ex Ruby & Saphire/RS107PsychicEnergy.tres",
"res://Cards/1 ex Ruby & Saphire/RS105FightingEnergy.tres","res://Cards/1 ex Ruby & Saphire/RS93DarknessEnergy.tres",
"res://Cards/1 ex Ruby & Saphire/RS94MetalEnergy.tres", "res://Cards/8 ex Deoxys/DX94HealEnergy.tres",
"res://Cards/1 ex Ruby & Saphire/RS95RainbowEnergy.tres"]
const conditions: Array[String] = ["Poison", "Burn", "Asleep", 
"Paralyze", "Confusion", "Shockwave", "Imprison"]
const evolutions: Array[String] = ["res://Cards/4 ex Team Magma VS Team Aqua/MA37MagmaMightyena.tres",
"res://Cards/1 ex Ruby & Saphire/RS42Mightyena.tres","res://Cards/1 ex Ruby & Saphire/RS37Lairon.tres",
"res://Cards/1 ex Ruby & Saphire/RS29Delcatty.tres","res://Cards/1 ex Ruby & Saphire/RS33Hariyama.tres",
"res://Cards/1 ex Ruby & Saphire/RS1Aggron.tres"]

var energy_type: int = 0
var evo_type: int = 0
var condition_type: int = 0
@onready var slots: Array[PokeSlot] = [$PokeSlot, $PokeSlot2]

# Called when the node enters the scene tree for the first time.
func _ready():
	slots[0].refresh()
	slots[1].refresh()

#region ENERGY
func _on_energy_options_item_selected(index: int):
	energy_type = index
	print(energy_cards[index])
	var card: Base_Card = load(energy_cards[index])
	print(card.name, card.energy_properties.type)
	print(card.energy_properties.how_display())

func add_energy_to(_target: int):
	pass # Replace with function body.

func remove_energy_from(_target: int):
	pass
#endregion

#region EVOLUTION
func _on_evolution_options_item_selected(index):
	evo_type = index
	var card: Base_Card = load(evolutions[evo_type])
	
	print(card.name," evolves from: ", card.pokemon_properties.evolves_from)
	
	for slot in slots:
		print("Can ",slot.current_card.name," evolve? ",slot.current_card.name == card.pokemon_properties.evolves_from)
	

func _on_evolve_pressed(_target: int):
	pass # Replace with function body.

#endregion

#region CONDITION
func change_conditiion(index: int):
	condition_type = index

func add_condition():
	pass

func add_imprision_to(_target: int):
	pass

func add_shockwave_to(_target: int):
	pass

func clear_conditions_from(_target: int):
	pass
#endregion

