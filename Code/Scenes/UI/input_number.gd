extends Control
class_name InputNum

@export var cap: int = -1
@export var title: String

@onready var rich_text_label: RichTextLabel = $PanelContainer/VBoxContainer/PanelContainer2/RichTextLabel
@onready var spin_box: SpinBox = $PanelContainer/VBoxContainer/SpinBox
@onready var confirm: Button = $PanelContainer/VBoxContainer/Confirm

var old_pos: Vector2 = Vector2.ZERO
#Consts
func _ready() -> void:
	Consts
	rich_text_label.clear()
	rich_text_label.append_text(title)
	
	if cap != -1:
		spin_box.max_value = cap

func _on_confirm_pressed() -> void:
	print("Return num: ", spin_box.value)
	Globals.control_disapear(self, .1, old_pos)
