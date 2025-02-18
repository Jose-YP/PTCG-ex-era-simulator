extends Control

@export var card: Base_Card

@onready var display_name: RichTextLabel = %Name
@onready var extra_identifier: RichTextLabel = %Extra
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
	pass # Replace with function body.

