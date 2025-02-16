extends Control

const energy_cards: Array[String] = ["res://Cards/1 ex Ruby & Saphire/RS104GrassEnergy.tres",
"res://Cards/1 ex Ruby & Saphire/RS108FireEnergy.tres","res://Cards/1 ex Ruby & Saphire/RS106WaterEnergy.tres",
"res://Cards/1 ex Ruby & Saphire/RS109LightningEnergy.tres","res://Cards/1 ex Ruby & Saphire/RS107PsychicEnergy.tres",
"res://Cards/1 ex Ruby & Saphire/RS105FightingEnergy.tres","res://Cards/1 ex Ruby & Saphire/RS93DarknessEnergy.tres",
"res://Cards/1 ex Ruby & Saphire/RS94MetalEnergy.tres", "res://Cards/8 ex Deoxys/DX94HealEnergy.tres",
"res://Cards/1 ex Ruby & Saphire/RS95RainbowEnergy.tres", "res://Cards/4 ex Team Magma VS Team Aqua/MA87MagmaEnergy.tres"]
const conditions: Array[String] = ["Poison", "Burn", "Asleep", 
"Paralysis", "Confusion", "Shockwave", "Imprison"]
const evolutions: Array[String] = ["res://Cards/4 ex Team Magma VS Team Aqua/MA37MagmaMightyena.tres",
"res://Cards/1 ex Ruby & Saphire/RS42Mightyena.tres","res://Cards/1 ex Ruby & Saphire/RS37Lairon.tres",
"res://Cards/1 ex Ruby & Saphire/RS29Delcatty.tres","res://Cards/1 ex Ruby & Saphire/RS33Hariyama.tres",
"res://Cards/1 ex Ruby & Saphire/RS1Aggron.tres"]

enum doing {NOTHING, CHECKING, SWAPPING, CHOOSING}

var what_are_you_doing: doing = doing.NOTHING
var energy_type: int = 0
var evo_type: int = 0
var condition_type: int = 0
var attack_box: Control

@onready var slots: Array[PokeSlot] = [$PokeSlot, $PokeSlot2]
@onready var evo_buttons: Array[Button] = [%EvoActive, %EvoBench]

func _ready():
	slots[1].slot_into($ActivePokemon)
	slots[0].slot_into($BenchPokemon)

#region ENERGY
func _on_energy_options_item_selected(index: int):
	energy_type = index
	print(energy_cards[index])
	var card: Base_Card = load(energy_cards[index])
	print(card.name, card.energy_properties.type)
	print(card.energy_properties.how_display())

func add_energy_to(target: int):
	slots[target].add_energy(load(energy_cards[energy_type]))

func remove_energy_from(_target: int):
	pass
#endregion

#region EVOLUTION
func _on_evolution_options_item_selected(index):
	evo_type = index
	var card: Base_Card = load(evolutions[evo_type])
	
	print(card.name," evolves from: ", card.pokemon_properties.evolves_from)
	
	for i in range(slots.size()):
		print("Can ",slots[i].current_card.name," evolve? ",slots[i].current_card.name == card.pokemon_properties.evolves_from)
		if slots[i].can_evolve_into(card): evo_buttons[i].disabled = false
		else: evo_buttons[i].disabled = true

func _on_evolve_pressed(target: int):
	var evo: Base_Card = load(evolutions[evo_type])
	if slots[target].can_evolve_into(evo):
		slots[target].evolve_card(evo)

#endregion

#region CONDITION
func change_conditiion(index: int):
	condition_type = index

func add_condition():
	slots[0].add_condition(conditions[condition_type])

func add_imprision_to(target: int):
	slots[target].set_imprison(true)

func add_shockwave_to(target: int):
	slots[target].set_shockwave(true)

func clear_conditions_from(target: int):
	slots[target].heal_status()
	slots[target].set_imprison(false)
	slots[target].set_shockwave(false)
#endregion

func _on_swap_pressed():
	var temp = slots[0].current_slot
	slots[0].slot_into(slots[1].current_slot)
	slots[1].slot_into(temp)
