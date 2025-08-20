extends Resource
class_name SlotChange

##Who recieves this change
@export var recieves: SlotAsk
##-1 means forever, otherwise how many turns is this active
@export var duration: int = -1
