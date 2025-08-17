extends Resource
class_name TypeChange

@export var ask: SlotAsk
@export_enum("Type", "Weakness", "Resistance") var which: int = 0
##If inclusive it will add [member new_type] on top of the preexisting member[br]
##Otherwise [member new_type] will replace the preexisting member
@export var inclusive: bool = false
@export var add_flags: bool = true
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var new_type: int = 0
