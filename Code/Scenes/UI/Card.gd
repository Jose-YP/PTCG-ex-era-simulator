extends Control

@export var current_slot: PokeSlot
@export var card: Base_Card

#--------------------------------------
#region ONREADY VARIABLES
@onready var pokedata: Pokemon = card.pokemon_properties
@onready var attackList: Node = %AttackList

@onready var default_types: Array[Control] = [%DefaultType, %DefaultType2]
@onready var weakness_nodes: Array[Node] = %Weaknesses.get_children()
@onready var resistance_nodes: Array[Node] = %Resistances.get_children()
@onready var retreat_cost: Array[Node] = %RetreatContainer.get_children()
@onready var ruleboxes: Array[Node] = %Ruleboxes.get_children()

@onready var display_name: RichTextLabel = %Name
@onready var extra_identifier: RichTextLabel = %Extra
@onready var max_hp: RichTextLabel = %HP
@onready var evoFrom: RichTextLabel = %EvoFrom
@onready var illustrator: RichTextLabel = %Illustrator
@onready var number: RichTextLabel = %Number
@onready var rarity: TabContainer = %Rarity
@onready var set_type: TabContainer = %Set

@onready var art: TextureRect = %Art
#endregion
#--------------------------------------

func _ready():
	#To fit multiple types in
	#--------------------------------------
	#region ENERGY SYMBOL MANAGEMENT
	var types: Array[String] = Conversions.flags_to_type_array(pokedata.type)
	var weaknesses: Array[String] = Conversions.flags_to_type_array(pokedata.weak)
	var resistances: Array[String] = Conversions.flags_to_type_array(pokedata.resist)
	
	for i in range(types.size()):
		default_types[i].display_type(types[i])
		default_types[i].show()
	
	for i in range(weaknesses.size()):
		weakness_nodes[i].display_type(weaknesses[i])
		weakness_nodes[i].show()
	
	for i in range(resistances.size()):
		resistance_nodes[i].display_type(resistances[i])
		resistance_nodes[i].show()
	
	for i in range(pokedata.retreat):
		retreat_cost[i].show()
	
	#endregion
	#--------------------------------------
	
	#--------------------------------------
	#region ATTACK NODE
	%AttackList.scale = Vector2(1,1)
	if current_slot:
		%AttackList.current_slot = current_slot
	else:
		%AttackList.current_card = card
	%AttackList.custom_minimum_size.y = %AttackList.current_height - 25
	#endregion
	#--------------------------------------
	
	#--------------------------------------
	#region SIMPLE EDITS
	make_text(display_name, card.name)
	make_text(max_hp, str("HP: ",pokedata.HP))
	if pokedata.considered & 1: make_text(extra_identifier, "Baby Pokemon")
	if pokedata.considered & 2: 
		ruleboxes[0].show()
		
	if pokedata.considered & 4: make_text(extra_identifier, "Delta Species")
	if pokedata.considered & 8: 
		ruleboxes[1].show()
	
	art.texture = card.image
	
	make_text(illustrator, str("Illus. ", card.illustrator))
	if pokedata.evolves_from != "":
		make_text(evoFrom, str("Evolves from ", pokedata.evolves_from))
	
	make_text(number, str(card.number, "/", Constants.expansion_counts[card.expansion]))
	rarity.current_tab = card.rarity
	set_type.current_tab = card.expansion
	#endregion
	#--------------------------------------

func make_text(node: RichTextLabel, text: String):
	node.clear()
	node.append_text(text)
