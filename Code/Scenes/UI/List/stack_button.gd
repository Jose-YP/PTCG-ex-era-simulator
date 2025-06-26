extends PanelContainer
class_name StackButton

@export var icon: CompressedTexture2D
@export var player: bool = true
@export var list: Constants.STACKS = Constants.STACKS.HAND

@onready var texture_rect: TextureRect = %TextureRect
@onready var rich_text_label: RichTextLabel = %RichTextLabel

var  current_num: int

func _ready() -> void:
	texture_rect.texture = icon
	update(-5)

func update(num: int):
	rich_text_label.clear()
	var text: String = Conversions.stack_into_string(list)
	current_num = num
	rich_text_label.append_text(str("[u]",text,"[/u]\n",num))

func _on_button_pressed() -> void:
	print("Bring up ", list)
	print()
	SignalBus.show_list.emit(player, list, Constants.STACK_ACT.PLAY if list == Constants.STACKS.HAND else Constants.STACK_ACT.LOOK)
