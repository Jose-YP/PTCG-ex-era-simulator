@icon("res://Art/Energy/48px-Psychic-attack.png")
extends Resource
class_name EnData

##How much energy does this provide on a succesful attatch
@export var number: int = 1
##React energy interacts with several poke-powers, so it needs to be categorized
##It doesn't provide different types however, so it's not considered as one
@export var react: bool = false
##Holon's energy are thier own categoory so they can be interacted with
@export_enum("None","FF","GL","WP") var holon_type: String = "None"
##What types will this data be considered[br]
##Providing multiple types means that one of the multiple types will be accounted for when counting energy
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 1023
