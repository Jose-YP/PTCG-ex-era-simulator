@icon("res://Art/ProjectSpecific/swap.png")
extends Resource
class_name PokeSwap

##Does the target choose which active mon to switch out?
##If not it's target
@export var choose_active: bool = false
##Who switches according to who
@export var chosing: Consts.SIDES = Consts.SIDES.DEFENDING
##Which side are they switching
@export var affected: Consts.SIDES = Consts.SIDES.DEFENDING
##What are thier options on this side
@export var slots: Consts.SLOTS = Consts.SLOTS.ALL

signal finished

var first: PokeSlot
var second: PokeSlot

func play_effect(reversable: bool = false):
	if affected == Consts.SIDES.BOTH:
		await switch(Consts.SIDES.ATTACKING, reversable)
		await switch(Consts.SIDES.DEFENDING, reversable)
	else:
		await switch(affected, reversable)
	
	finished.emit()

func switch(aff: Consts.SIDES, reversable: bool):
	var first_candidate: Callable = func(slot: PokeSlot):
		return slot.is_in_slot(aff, Consts.SLOTS.BENCH\
		 if choose_active else Consts.SLOTS.TARGET)
	var second_candidate: Callable = func(slot: PokeSlot):
		return slot.is_in_slot(aff, Consts.SLOTS.ACTIVE)
	
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
