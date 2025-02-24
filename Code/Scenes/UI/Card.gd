extends Control

@export var card_slot: PokeSlot

@onready var card: Base_Card = card_slot.current_card
@onready var pokedata: Pokemon = card.pokemon_properties
@onready var display_name: RichTextLabel = %Name
@onready var extra_identifier: RichTextLabel = %Extra
@onready var max_hp: RichTextLabel = %HP
@onready var default_types: Array[Control] = [%DefaultType, %DefaultType2]
@onready var art: TextureRect = %Art
@onready var evoFrom: RichTextLabel = %EvoFrom
@onready var illustrator: RichTextLabel = %Illustrator
@onready var attacks: Control = %AttackList
@onready var weaknesses: Array[Control] = [%WeaknessType, %WeaknessType2]
@onready var resistances: Array[Control] = [%ResistanceType, %ResistanceType2]
@onready var retreat_array: Array[Node] = %RetreatContainer.get_children()
@onready var number: RichTextLabel = %Number
@onready var rarity: TabContainer = %Rarity
@onready var set_type: TabContainer = %Set

# Called when the node enters the scene tree for the first time.
func _ready():
	%AttackList.current_slot = card_slot
	
	make_text(display_name, card.name)
	make_text(max_hp, str("HP:",pokedata.HP))
	
	art.texture = card.image
	
	make_text(illustrator, str("Illus. ", card.illustrator))
	
	make_text(number, str(card.number, "/", Constants.expansion_counts))
	rarity.current_tab = card.rarity
	set_type.current_tab = card.expansion

func make_text(node: RichTextLabel, text: String):
	node.clear()
	node.append_text(text)

