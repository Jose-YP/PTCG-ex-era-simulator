extends Node

#For any node that can bring up the check card display
var checking: bool = false
var dragging: bool = false
var checked_card: Control
var fundies: Fundies
var full_ui: FullBoardUI

signal enter_check
signal exit_check

func show_card(card: Base_Card, parent: Node, ancestor: Node = null):
	if checked_card:
		remove_card()
	
	var considered: String = card.card_display()
	var node_tween: Tween = get_tree().create_tween().set_parallel(true)
	var card_display: Node
	match considered:
		"Pokemon":
			card_display = load("res://Scenes/UI/CardDisplay/PokemonCard.tscn").instantiate()
			card_display.checking = true
		"Trainer":
			card_display = Constants.trainer_card.instantiate()
		"Energy":
			card_display = Constants.energy_card.instantiate()
	
	card_display.card = card
	card_display.top_level = true
	#card_display.position = get_window().size / 2 #Put on center of screen
	card_display.scale = Vector2(.05, .05)
	card_display.modulate = Color.TRANSPARENT
	card_display.name = str(card.name, " Card")
	parent.add_child(card_display)
	
	if ancestor:
		ancestor.display = card_display
		ancestor.connect_display()
	
	node_tween.tween_property(card_display, "scale", Vector2.ONE, .1)
	node_tween.tween_property(card_display, "modulate", Color.WHITE, .1)
	checked_card = card_display
	checked_card.z_index = 1
	#checked_card.connect("tree")
	checking_card()

func remove_card():
	control_disapear(checked_card, .1, checked_card.global_position)

func checking_card():
	checking = true
	enter_check.emit()

func reset_check():
	checking = false
	exit_check.emit()

func control_disapear(node: Node, timing: float, old_position: Vector2 = Vector2.ZERO):
	var disapear_tween: Tween = get_tree().create_tween().set_parallel()
	
	disapear_tween.tween_property(node, "position", old_position, timing)
	disapear_tween.tween_property(node, "modulate", Color.TRANSPARENT, timing)
	disapear_tween.tween_property(node, "scale", Vector2(.1,.1), timing)
	
	await disapear_tween.finished
	
	node.queue_free()

func make_can_evo_from(evo: Base_Card) -> Callable:
	var evo_func: Callable = func can_evo_from(slot: PokeSlot):
		if slot.current_card:
			return slot.current_card.name == evo.pokemon_properties.evolves_from
		else:
			return false
	return evo_func
