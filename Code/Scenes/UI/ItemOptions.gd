extends Control

@export var timing: float = .1
@export_flags("Basic", "Evolution", "Item",
"Supporter", "Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var card_flags: int = 0

@onready var items: Array[Node] = $PlayAs/Items.get_children()

signal play_as(card_flag: int)

var old_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	#Check for every option except for check, every card should be able to do that
	for i in range($PlayAs/Items.get_child_count() - 1):
		if card_flags & 2 ** i:
			items[i].show()
			items[i].pressed.connect(emit_play_as.bind(i))
		
		else : items[i].hide()
	
	%Check.pressed.connect(on_check_pressed)
	Globals.enter_check.connect(on_entered_check)

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

func emit_play_as(flag: int):
	if not Globals.checking:
		print("PLAY ", Constants.allowed_list_flags[flag])
		play_as.emit(flag)

func on_check_pressed():
	if not Globals.checking:
		get_parent().show_card()

func on_entered_check():
	for i in range($PlayAs/Items.get_child_count()):
		items[i].disabled = true

func on_exited_check():
	for i in range($PlayAs/Items.get_child_count()):
		items[i].disabled = false
