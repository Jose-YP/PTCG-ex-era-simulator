extends Resource
class_name SlotChange

#Shared by: Buff, Disable, OverRide, TypeChange

##How will this change be applied?[br]
##[enum Slot] Apply change to slots that meet [member recieves].[br]
##*Best for attacks that only apply chnages at the very moment they attack[br]
##*Energy which only apply to the slot that has them[br]
##[enum Side] Apply the change to a side so it only clears after conditions for making it fail.
##[br]Best for ability passives which are active as long as thier condition are met

@export_enum("Slot", "Side") var application: String = "Slot"
##Who recieves this change
@export var recieves: SlotAsk
##-1 means ignore duration, check a prompt/ask to see if the effect should continue
##[br]-2 means forever, no conditions need to be checked afterwards
##[br]otherwise the effect lasts for this many turns 
@export var duration: int = -1
