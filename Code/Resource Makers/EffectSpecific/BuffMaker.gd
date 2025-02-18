extends Resource
class_name Buff

@export_group("Buff & Debuff")
##Who recieves the buff?
@export_enum("PlayerAll", "OpponentAll", "Self",
"Defender", "Both Active", "Both Defending") var buff_target: int = 0
##How much more damage to the active spot?
@export_range(-120, 120, 10) var attack_damage: int = 0
##How much less damage should be taken from opponent
@export_range(-120, 120, 10) var defense: int = 0
##Is it applied before or after weak/res
@export var after_weak_res: bool = true
