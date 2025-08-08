extends Control

@export_dir var directory: String
@export var effect_types: Array[String]
@export var other_test: Base_Card

var cards_path: PackedStringArray
var cards: Array[Base_Card]

func _on_button_pressed() -> void:
	var card_filter: Array[Base_Card]
	cards_path = ResourceLoader.list_directory(directory)
	for path in cards_path:
		var card: Base_Card = ResourceLoader.load(directory+"/"+path)
		cards.append(card)
		if card.name == "Delcatty":
			pass
		
		if ToolBool.has_effect(card, effect_types):
			card_filter.append(card)
			print(card.get_formal_name())
	
	print(card_filter)
