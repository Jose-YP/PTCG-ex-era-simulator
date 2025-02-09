extends Resource
class_name Ask

@export_group("To attack")
@export_range(-1,5) var bench_size: int = -1

@export_group("Before Attacking")
@export var coin_flip: CoinFlip
