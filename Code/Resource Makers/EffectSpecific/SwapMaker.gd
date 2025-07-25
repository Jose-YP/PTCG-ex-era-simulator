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
##Which of Active/Bench should be autofilled with target, if any?
@export_enum("None", "Active", "Bench") var autofill: String = "None"

signal finished

var bench_swap: PokeSlot
var active_swap: PokeSlot

func play_effect(reversable: bool = false):
	if affected == Consts.SIDES.BOTH:
		await switch(Consts.SIDES.ATTACKING, reversable)
		await switch(Consts.SIDES.DEFENDING, reversable)
	else:
		await switch(affected, reversable)
	
	finished.emit()

func switch(aff: Consts.SIDES, reversable: bool):
	var bench_candidate: Callable = func(slot: PokeSlot):
		return slot.is_in_slot(aff, Consts.SLOTS.BENCH\
		 if autofill != "Bench" else Consts.SLOTS.TARGET)
	var active_candidate: Callable = func(slot: PokeSlot):
		return slot.is_in_slot(aff, Consts.SLOTS.ACTIVE\
		if autofill != "Active" else Consts.SLOTS.TARGET)
	
	#Get whichever active pokemon are allowed to switch
	bench_swap = await Globals.fundies.card_player.get_choice_candidates(\
	"Choose a benched Pokemon to switch", bench_candidate, reversable)
	if bench_swap == null: return
	active_swap = await Globals.fundies.card_player.get_choice_candidates(\
	"Choose an active Pokemon to switch", active_candidate, reversable)
	if active_swap == null: return
	#Get whichever benched pokemon are allowed to switch
	
	#Swap the data between eachother
	var temp_slot: UI_Slot = active_swap.ui_slot
	active_swap.alleviate_all()
	active_swap.slot_into(bench_swap.ui_slot)
	bench_swap.slot_into(temp_slot)
	
	finished.emit()
