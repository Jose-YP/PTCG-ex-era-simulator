@icon("uid://bfnxpo3hqsr3y")
extends Control

@export var change: SlotChange

func determine_change(chng: SlotChange):
	change = chng
	
	%Description.clear()
	%Icon.display_change(change)
	%Description.append_text(change.describe())
	
