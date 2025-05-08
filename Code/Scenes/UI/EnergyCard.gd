extends Control

@export var card: Base_Card

@onready var engData: Energy = card.energy_properties
@onready var display_name: RichTextLabel = %Name
@onready var extra_identifier: RichTextLabel = %Extra
@onready var default_types: Array[Control] = [%DefaultType, %DefaultType2, %DefaultType3]
@onready var art: TextureRect = %Art
@onready var effect_text: RichTextLabel = %Effect
@onready var illustrator: RichTextLabel = %Illustrator
@onready var number: RichTextLabel = %Number
@onready var rarity: TabContainer = %Rarity
@onready var set_type: TabContainer = %Set

# Called when the node enters the scene tree for the first time.
func _ready():
	make_text(display_name, card.name)
	make_text(extra_identifier, engData.considered)
	
	for num in range(engData.number):
		default_types[num].display_type(engData.how_display())
		default_types[num].show()
	
	art.texture = card.image
	
	if card.illustrator != "":
		make_text(illustrator, str("Illus. ", card.illustrator))
	
	var final_text: String = Conversions.reformat(engData.description)
	make_text(effect_text, final_text)
	
	make_text(number, str(card.number, "/", Constants.expansion_counts[card.expansion]))
	rarity.current_tab = card.rarity
	set_type.current_tab = card.expansion

func make_text(node: RichTextLabel, text: String):
	node.clear()
	node.append_text(text)
