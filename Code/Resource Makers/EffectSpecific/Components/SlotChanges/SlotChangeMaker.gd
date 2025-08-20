extends Resource
class_name SlotChange

#Shared by: Buff, Disable, OverRide, TypeChange

##Who recieves this change
@export var recieves: SlotAsk
##-1 means ignore duration, check a prompt/ask to see if the effect should continue
##[br]-2 means forever, no conditions need to be checked afterwards
##[br]otherwise the effect lasts for this many turns 
@export var duration: int = -1
