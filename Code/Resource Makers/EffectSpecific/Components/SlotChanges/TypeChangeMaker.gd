extends SlotChange
class_name TypeChange

@export_enum("Type", "Weakness", "Resistance") var which: int = 0
##If [member mode] it will add [member new_type] on top of the preexisting member[br]
##Otherwise [member new_type] will replace the preexisting member
@export_enum("Add", "Subtract", "Replace") var mode: String = "Replace"
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var new_type: int = 0
@export var en_card_dependant: bool
