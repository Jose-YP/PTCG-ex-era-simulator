extends Control

@export var timing: float = .1
@export_flags("Basic", "Evolution", "Item",
"Supporter", "Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var card_flags: int = 0
@export_enum("Play", "Tutor", "Discard", "Look") var interaction: String = "Hand"

@onready var items: Array[Node] = $PlayAs/Items.get_children()

signal play_as(card_flag: int, card: Base_Card)
signal transfer()

var old_position: Vector2
var origin_button: Button

#--------------------------------------
#region INITALIZATION AND REMOVAL
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range($PlayAs/Items.get_child_count() - 1): items[i].hide()
	#Tutor and discard will also need to vary depening on card_flags
	match interaction:
		"Play":
			#Check for every option except for check, every card should be able to do that
			for i in range($PlayAs/Items.get_child_count() - 1):
				if card_flags & 2 ** i:
					items[i].show()
					items[i].pressed.connect(emit_play_as.bind(i))
		"Tutor":
			%Tutor.show()
		"Discard":
			%Discard.show()
		"Look":
			pass
		_: push_error(interaction, " Not an actual interaction")
	
	Globals.enter_check.connect(on_entered_check)
	Globals.exit_check.connect(on_exited_check)
	play_as.connect(Callable(SignalBus, "call_action"))

func bring_up():
	var appear_tween: Tween = get_tree().create_tween().set_parallel() 
	old_position = position
	
	appear_tween.tween_property(self, "position", position - Vector2(50,50), timing)
	appear_tween.tween_property(self, "modulate", Color.WHITE, timing)
	appear_tween.tween_property(self, "scale", Vector2.ONE, timing)

func disapear():
	var disapear_tween: Tween = get_tree().create_tween().set_parallel()
	
	disapear_tween.tween_property(self, "position", old_position, timing)
	disapear_tween.tween_property(self, "modulate", Color.TRANSPARENT, timing)
	disapear_tween.tween_property(self, "scale", Vector2(.1,.1), timing)
	
	await disapear_tween.finished
	
	queue_free()
#endregion
#--------------------------------------

#--------------------------------------
#region SIGNALS
func emit_play_as(flag: int):
	if not Globals.checking:
		play_as.emit(flag, origin_button.card)

func _on_check_pressed():
	if not Globals.checking:
		print(get_parent())
		origin_button.show_card()

func _on_tutor_pressed() -> void:
	print("Tutor ", origin_button.card.name, " from ", origin_button.parent.identifier.text)
	SignalBus.swap_card_location.emit(origin_button.card, origin_button.parent.identifier.text, "Hand")

func _on_discard_pressed() -> void:
	print("Discard ", origin_button.card.name, " from ", origin_button.parent.identifier.text)
	SignalBus.swap_card_location.emit(origin_button.card, origin_button.parent.identifier.text, "Discard")

func on_entered_check():
	for i in range($PlayAs/Items.get_child_count()):
		items[i].disabled = true

func on_exited_check():
	for i in range($PlayAs/Items.get_child_count()):
		items[i].disabled = false
#endregion
#--------------------------------------
