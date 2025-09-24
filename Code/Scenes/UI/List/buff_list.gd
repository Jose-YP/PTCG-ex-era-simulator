@icon("uid://bfnxpo3hqsr3y")
extends Control

@export var change: SlotChange

func determine_change():
	%Description.clear()
	%Description.append_text(change.describe())
	
