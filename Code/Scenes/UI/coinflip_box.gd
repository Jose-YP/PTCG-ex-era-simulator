@icon("res://Art/Coins/BreloomFirst.png")
extends Control

@export var coinflip: CoinFlip
@export var coin_scene: PackedScene

@onready var coin_container: HBoxContainer = %CoinContainer
@onready var top: PanelContainer = $VBoxContainer/Footer
@onready var bottom: PanelContainer = $VBoxContainer/Footer2
@onready var cooldown: Timer = $Cooldown

var flip_results: Array[bool]
var shown_results: Dictionary[bool, int] = {true: 0, false: 0}

func _ready() -> void:
	#For testing coinflips will be done here
	flip_results = coinflip.get_flip_array(coinflip.activate_CF())
	flip_results.shuffle()
	#on implementation the result should be found beforehand
	
	top.setup("[center]Coinflips")
	bottom.setup(str("[center]Heads: ", shown_results[true],
	 " Tails: ", shown_results[false]))
	
	for result in flip_results:
		var new_coin = coin_scene.instantiate()
		new_coin.result = result
		new_coin.shown.connect(display_results.bind(result))
		new_coin.add_to_group("coins")
		coin_container.add_child(new_coin)

func display_results(result: bool):
	shown_results[result] += 1
	bottom.setup(str("[center]Heads: ", shown_results[true],
	 " Tails: ", shown_results[false]))

func _on_begin_timeout() -> void:
	var coins: Array[Node] = get_tree().get_nodes_in_group("coins")
	for i in range(coins.size()):
		var coin: Node = coins[i]
		coin.play_result()
		cooldown.start()
		if i > 3:
			var scroll_tween: Tween = create_tween()
			scroll_tween.tween_property(%CoinScroll, "scroll_horizontal", 
			%CoinScroll.scroll_horizontal + 42, cooldown.wait_time)
		await cooldown.timeout
