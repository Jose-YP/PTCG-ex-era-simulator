@icon("res://Art/Rarities/31px-Rarity_Uncommon.png")
extends Control

#--------------------------------------
#region VARIABLES
@export var card: Base_Card

@onready var trainerData: Trainer = card.trainer_properties
@onready var display_name: RichTextLabel = %Name
@onready var extra_identifier: RichTextLabel = %Extra
@onready var art: TextureRect = %Art
@onready var class_text: RichTextLabel = %ClassText
@onready var effect_text: RichTextLabel = %Effect
@onready var illustrator: RichTextLabel = %Illustrator
@onready var number: RichTextLabel = %Number
@onready var rarity: TabContainer = %Rarity
@onready var set_type: TabContainer = %Set

@onready var close_button: Close_Button = %CloseButton
#endregion
#--------------------------------------

# Called when the node enters the scene tree for the first time.
func _ready():
	make_text(display_name, card.name)
	make_text(extra_identifier, trainerData.considered)
	
	art.texture = card.image
	
	if card.illustrator != "":
		make_text(illustrator, str("Illus. ", card.illustrator))
	
	#What kind of class text should be input if any
	var final_class_txt: String
	if trainerData.specific_requirement == "":
		var index: int = Consts.trainer_classes.find(trainerData.considered)
		final_class_txt = Consts.class_texts[index]
	final_class_txt += Convert.reformat(trainerData.specific_requirement, card.name)
	make_text(class_text, final_class_txt)
	make_text(%Effect, trainerData.description)
	
	if trainerData.provided_attack:
		%AttackItem.attack = trainerData.provided_attack
		%AttackItem.attackButton.theme_type_variation = "TrainerButton"
		%AttackItem.set_attack()
		%AttackItem.show()
	
	make_text(number, str(card.number, "/", Consts.expansion_counts[card.expansion]))
	rarity.current_tab = card.rarity
	set_type.current_tab = card.expansion

func make_text(node: RichTextLabel, text: String):
	node.clear()
	node.append_text(text)

func _on_tree_exiting() -> void:
	Globals.checking = false
