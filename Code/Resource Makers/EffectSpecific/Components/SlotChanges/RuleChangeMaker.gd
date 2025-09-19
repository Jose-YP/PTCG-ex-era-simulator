extends SlotChange
class_name RuleChange

@export var bench_cap: int = -1
@export var coin_rules: Consts.COIN_RULES
@export var condition_rules: Dictionary[Consts.CONDITIONS, CondRules] = {}
