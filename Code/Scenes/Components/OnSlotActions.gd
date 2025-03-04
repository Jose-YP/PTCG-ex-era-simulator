extends Node

@export var poke_slots: Array[PokeSlot]

#--------------------------------------
#region MANAGING CARD PLAY
#For items, supporters, rsm
func play_on_nothing():
	pass

#For evolutions, tools, tms and energy
func play_attatch_to():
	pass

#For basic mons, fossils and stadiums
func play_place_on():
	pass
#endregion
#--------------------------------------

#--------------------------------------
#region DETERMINING EFFECTS
func scope_effect():
	pass

#endregion
#--------------------------------------

#--------------------------------------
#region EFFECT TYPES
func condition_effect(_condition: Condition):
	pass

func draw_effect(_card_draw: Counter):
	pass

func buff_effect(_buff: Buff):
	pass

func card_disrupt_effect(_card_dis: CardDisrupt):
	pass

func disable_effect(_disable: Disable):
	pass

func energy_mov_effect(_en_mov: EnMov):
	pass

func dmg_manip_effect(_dmg_manip: DamageManip):
	pass

func search_effect(_search: Search):
	pass

#endregion
#--------------------------------------
