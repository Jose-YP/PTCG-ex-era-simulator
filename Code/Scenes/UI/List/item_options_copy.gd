extends Control
class_name ItemOptions

@export var timing: float = .1
@export_flags("Basic", "Evolution", "Item",
 "Supporter", "Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var card_flags: int = 0
@export var stack_act: Consts.STACK_ACT = Consts.STACK_ACT.PLAY

@onready var items: Array[Node] = $PlayAs/Items.get_children()

signal play_as(card_flag: int, card: Base_Card)

var old_position: Vector2
var origin_button: PlayingButton
var home: bool

#--------------------------------------
#region INITALIZATION AND REMOVAL
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range($PlayAs/Items.get_child_count() - 1): items[i].hide()
	#Tutor and discard will also need to vary depening on card_flags
	match stack_act:
		Consts.STACK_ACT.PLAY:
			#Check for every option except for check, every card should be able to do that
			for i in range($PlayAs/Items.get_child_count() - 1):
				if card_flags & 2 ** i:
					items[i].show()
					items[i].pressed.connect(emit_play_as.bind(i))
		Consts.STACK_ACT.TUTOR:
			if origin_button.is_tutored():
				%Cancel.show()
			else:
				%Tutor.show()
		Consts.STACK_ACT.DISCARD:
			if origin_button.is_tutored():
				%Cancel.show()
			else:
				%Discard.show()
		Consts.STACK_ACT.LOOK:
			pass
		_: push_error(stack_act, " Not an actual stack_act")
	
	Globals.enter_check.connect(on_entered_check)
	Globals.exit_check.connect(on_exited_check)
	play_as.connect(Callable(SignalBus, "call_action"))

func bring_up():
	var appear_tween: Tween = get_tree().create_tween().set_parallel() 
	old_position = position
	
	appear_tween.tween_property(self, "position", position - Vector2(50,50), timing)
	appear_tween.tween_property(self, "modulate", Color.WHITE, timing)
	appear_tween.tween_property(self, "scale", Vector2.ONE, timing)

#endregion
#--------------------------------------

#--------------------------------------
#region SIGNALS
#Record source here, no need to record target as anything in particular
func emit_play_as(flag: int):
	if not Globals.checking:
		Globals.control_disapear(self, .1, old_position)
		play_as.emit(flag, origin_button.card)
		origin_button.parent.finished.emit()

func _on_check_pressed():
	if not Globals.checking:
		Globals.show_card(origin_button.card, origin_button)

#signal swap_card_location(card: Array[Base_Card], from: Consts.STACKS, to: String)

#Tutor and discard record source and target on effect call
func _on_tutor_pressed() -> void:
	print("Tutor ", origin_button.card.name, " from ", origin_button.parent.stack)
	SignalBus.tutor_card.emit(origin_button.card)
	Globals.control_disapear(self, .1, old_position)

func _on_discard_pressed() -> void:
	print("Discard ", origin_button.card.name, " from ", origin_button.parent.stack)
	SignalBus.tutor_card.emit(origin_button.card)
	Globals.control_disapear(self, .1, old_position)

func on_entered_check():
	for i in range($PlayAs/Items.get_child_count()):
		items[i].disabled = true

func on_exited_check():
	for i in range($PlayAs/Items.get_child_count()):
		items[i].disabled = false

func _on_cancel_pressed() -> void:
	SignalBus.cancel_tutor.emit(origin_button)
	Globals.control_disapear(self, .1, old_position)

#endregion
#--------------------------------------
