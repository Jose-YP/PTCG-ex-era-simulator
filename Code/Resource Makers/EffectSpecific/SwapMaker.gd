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

func play_effect():
	print("PLAY SWAP")
	#Get whichever active pokemon are allowed to switch
	Globals.fundies.ui_actions.get_choice(null, "Choose and active Pokemon to switch")
	#Get whichever benched pokemon are allowed to switch
	
	#Swap the data between eachother
	
