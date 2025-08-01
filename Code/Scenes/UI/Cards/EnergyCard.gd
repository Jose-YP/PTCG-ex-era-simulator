@icon("res://Art/Energy/48px-Colorless-attack.png")
extends Control

#--------------------------------------
#region VARIABLES
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

@onready var movable: Draggable_Control = %Movable
@onready var close_button: Close_Button = %CloseButton
#endregion
#--------------------------------------

# Called when the node enters the scene tree for the first time.
func _ready():
	make_text(display_name, card.name)
	make_text(extra_identifier, engData.considered)
	
	for num in range(engData.success_provide.number):
		default_types[num].display_type(engData.success_provide.get_string())
		default_types[num].show()
	
	art.texture = card.image
	
	if card.illustrator != "":
		make_text(illustrator, str("Illus. ", card.illustrator))
	
	var final_text: String = Convert.reformat(engData.description)
	make_text(effect_text, final_text)
	
	make_text(number, str(card.number, "/", Consts.expansion_counts[card.expansion]))
	rarity.current_tab = card.rarity
	set_type.current_tab = card.expansion

func make_text(node: RichTextLabel, text: String):
	node.clear()
	node.append_text(text)

func _on_tree_exiting() -> void:
	Globals.checking = false
