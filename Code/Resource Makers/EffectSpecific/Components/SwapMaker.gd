@icon("res://Art/ProjectSpecific/swap.png")
extends Resource
class_name PokeSwap

##If this is true then the effect can be cancelled no matter what, move onto next effect
@export var force_reversable: bool = false
##If this is true the swapped in slot will be treated as the new target
@export var record_target: bool = false
##Does the source choose which active mon to switch out?
##If not it's the affected side
@export var choose_active: bool = false
##Swap both current active members of chosen side?
@export var both_active: bool = false
##Who switches according to who
@export var chosing: Consts.SIDES = Consts.SIDES.DEFENDING
##Which side are they switching
@export var affected: Consts.SIDES = Consts.SIDES.DEFENDING
##Which of Active/Bench should be autofilled with target, if any?
@export_enum("None", "Active", "Bench") var autofill: String = "None"

signal finished

var bench_swap: PokeSlot
var active_swap: PokeSlot
var pre_swapped: Array[PokeSlot]

#Q. Wobbuffet vs. Ninetales-EX: I try to use "Intense Glare"
#(switch 1 your opponent's Benched Pokémon with 1 of the Defending Pokémon...) on Wobb.
#Does Wobbuffet's Safeguard Poké-BODY prevent the switch?
#A. Yes it would prevent the switch. In addition, you could not do Intense Glare to
#bring up a Wobbuffet from the bench either, as that would be an 
#"effect being done to Wobbuffet by a Pokémon-EX." (Feb 24, 2005 PUI Rules Team)

#Q. What happens if I use Swoop!Teleporter to switch a poisoned Dunsparce for
#a Roselia with "Thick Skin" (can't be affected by Special Conditions)?
#Does the status effect go away or does it stay on because it was already on?
#A. Well, since Thick Skin says it "can't be affected by Special Conditions",
#the status effect would be removed automatically when Swoop'ing for Roselia. (Dec 2, 2004 PUI Rules Team) 

#Q. If I use Mew's "Type Change" power to copy a new type for Mew, and 
#then I play Swoop!Teleporter to switch Mew for a new Basic Pokémon, 
#does the new Pokémon keep the modified type Mew was changed into?
#A. Yes. It's an effect, and any effect on the original Pokémon stays with 
#the new one when you play Swoop!. (Mar 9, 2006 PUI Rules Team) 

func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	if both_active:
		if affected == Consts.SIDES.BOTH:
			await specific_switch(Consts.SIDES.ATTACKING, reversable)
			await specific_switch(Consts.SIDES.DEFENDING, reversable)
		else:
			await specific_switch(affected, reversable)
	elif affected == Consts.SIDES.BOTH:
		await switch(Consts.SIDES.ATTACKING, reversable)
		await switch(Consts.SIDES.DEFENDING, reversable)
	else:
		await switch(affected, reversable)
	
	bench_swap = null
	active_swap = null
	pre_swapped.clear()
	
	finished.emit()

func switch(aff: Consts.SIDES, reversable: bool, pre_active: PokeSlot = null):
	var bench_candidate: Callable = func(slot: PokeSlot):
		return slot.is_filled() and not slot in pre_swapped and\
		slot.is_in_slot(aff, Consts.SLOTS.BENCH\
		if autofill != "Bench" else Consts.SLOTS.TARGET)
	bench_swap = await Globals.fundies.card_player.get_choice_candidates(\
	"Choose a benched Pokemon to switch", bench_candidate, reversable)
	if bench_swap == null: return
	
	if pre_active:
		active_swap = pre_active
	else:
		var active_candidate: Callable = func(slot: PokeSlot):
			return slot.is_filled() and not slot in pre_swapped and\
			slot.is_in_slot(aff, Consts.SLOTS.ACTIVE\
			if autofill != "Active" else Consts.SLOTS.TARGET)
	
		active_swap = await Globals.fundies.card_player.get_choice_candidates(\
		"Choose an active Pokemon to switch", active_candidate, reversable)
	if active_swap == null: return
	#Get whichever benched pokemon are allowed to switch
	
	#Swap the data between eachother
	var temp_slot: UI_Slot = active_swap.ui_slot
	active_swap.alleviate_all()
	active_swap.slot_into(bench_swap.ui_slot)
	active_swap.refresh_swap()
	bench_swap.slot_into(temp_slot)
	bench_swap.refresh_swap()
	
	active_swap.swap.emit(active_swap.get_slot_pos())
	bench_swap.swap.emit(active_swap.get_slot_pos())
	
	Globals.fundies.check_all_passives()
	
	finished.emit()

func specific_switch(aff: Consts.SIDES, reversable: bool):
	#BSP 24 Chimecho's Resonate:
	#Your opponent switches each Defending Pokémon with his or her Benched Pokémon.
	#If opp has only 1 Benched Pokémon, you choose the Defending Pokémon to switch.
	
	var bench: Array[PokeSlot] = Globals.full_ui.get_poke_slots(affected, Consts.SLOTS.BENCH)
	bench = Globals.fundies.filter_immune(Consts.IMMUNITIES.ATK_EFCT_OPP, bench)
	
	match bench.size():
		0:
			return
		1:
			await switch(aff, reversable)
			finished.emit()
			return
		_:
			var active: Array[PokeSlot] = Globals.full_ui.get_poke_slots(aff, Consts.SLOTS.ACTIVE)
			active = Globals.fundies.filter_immune(Consts.IMMUNITIES.ATK_EFCT_OPP, active)
			
			for slot in active:
				await switch(aff, reversable, slot)
				pre_swapped.append(slot)
