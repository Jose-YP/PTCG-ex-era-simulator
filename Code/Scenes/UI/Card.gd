extends Control

@export var current_slot: PokeSlot
@export var card: Base_Card

@onready var pokedata: Pokemon = card.pokemon_properties
@onready var display_name: RichTextLabel = %Name
@onready var extra_identifier: RichTextLabel = %Extra
@onready var max_hp: RichTextLabel = %HP
@onready var default_types: Array[Control] = [%DefaultType, %DefaultType2]
@onready var art: TextureRect = %Art
@onready var attackList: Node = %AttackList
@onready var evoFrom: RichTextLabel = %EvoFrom
@onready var illustrator: RichTextLabel = %Illustrator
@onready var number: RichTextLabel = %Number
@onready var rarity: TabContainer = %Rarity
@onready var set_type: TabContainer = %Set

# Called when the node enters the scene tree for the first time.
func _ready():
	%AttackList.scale = Vector2(1,1)
	if current_slot:
		%AttackList.current_slot = current_slot
	else:
		%AttackList.current_card = card
	make_text(display_name, card.name)
	make_text(max_hp, str("HP:",pokedata.HP))
	
	art.texture = card.image
	
	make_text(illustrator, str("Illus. ", card.illustrator))
	
	make_text(number, str(card.number, "/", Constants.expansion_counts[card.expansion]))
	rarity.current_tab = card.rarity
	set_type.current_tab = card.expansion
	
	%AttackList.custom_minimum_size.y = %AttackList.current_height - 25

func make_text(node: RichTextLabel, text: String):
	node.clear()
	node.append_text(text)
