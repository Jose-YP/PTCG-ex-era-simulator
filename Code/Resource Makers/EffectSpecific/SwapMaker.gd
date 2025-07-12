@icon("res://Art/ProjectSpecific/swap.png")
extends Resource
class_name PokeSwap

##Does the target choose which active mon to switch out?
##If not it's target
@export var choose_active: bool = false
##Who switches according to who
@export var chosing: Constants.SIDES = Constants.SIDES.DEFENDING
##Which side are they switching
@export var affected: Constants.SIDES = Constants.SIDES.DEFENDING
##What are thier options on this side
@export var slots: Constants.SLOTS = Constants.SLOTS.ALL

signal finished

var first: PokeSlot
var second: PokeSlot

func play_effect(reversable: bool = false):
	if affected == Constants.SIDES.BOTH:
		await switch(Constants.SIDES.ATTACKING, reversable)
		await switch(Constants.SIDES.DEFENDING, reversable)
	else:
		await switch(affected, reversable)
	
	finished.emit()

func switch(aff: Constants.SIDES, reversable: bool):
	var first_candidate: Callable = func(slot: PokeSlot):
		return slot.is_in_slot(aff, Constants.SLOTS.BENCH\
		 if choose_active else Constants.SLOTS.TARGET)
	var second_candidate: Callable = func(slot: PokeSlot):
		return slot.is_in_slot(aff, Constants.SLOTS.ACTIVE)
	
	#Get whichever active pokemon are allowed to switch
	first = await Globals.fundies.card_player.get_choice_candidates(\
	"Choose a benched Pokemon to switch", first_candidate, reversable)
	if first == null: return
	second = await Globals.fundies.card_player.get_choice_candidates(\
	"Choose an active Pokemon to switch", second_candidate, reversable)
	if second == null: return
	#Get whichever benched pokemon are allowed to switch
	
	#Swap the data between eachother
	var temp_slot: UI_Slot = second.ui_slot
	second.slot_into(first.ui_slot)
	first.slot_into(temp_slot)
	
	finished.emit()
