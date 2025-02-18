extends Resource
class_name EnMov

@export_group("Energy Movement")
@export_enum("Basic", "Special", "Any") var energy_move_type: int = 0
@export var move_ammount: int = -1
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 0
@export var energy_ammount: int = 0
