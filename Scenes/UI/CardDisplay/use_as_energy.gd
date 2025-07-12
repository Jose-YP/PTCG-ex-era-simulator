extends PanelContainer

@onready var types: TypeContainer = $HBoxContainer/Types
@onready var rich_text_label: RichTextLabel = $HBoxContainer/RichTextLabel

func setup(en_prop: Energy):
	rich_text_label.clear()
	rich_text_label.append_text(Conversions.reformat(en_prop.description))
	types.display_type(en_prop.success_provide.get_string())
