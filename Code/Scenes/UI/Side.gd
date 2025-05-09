extends Control

@onready var ui_slots: Array[Node] = %Active.get_children() + %Bench.get_children()
