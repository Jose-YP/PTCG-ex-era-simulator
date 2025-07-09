@icon("res://Art/Coins/BreloomFirst.png")
extends Control

@export var coin_heads: CompressedTexture2D = load("res://Art/Coins/BreloomFirst.png")

@onready var flip_anim: AnimatedSprite2D = %FlipAnim
@onready var heads: TextureRect = %Heads

var result: bool

signal shown

func _ready() -> void:
	heads.texture = coin_heads

func play_result():
	if result: %AnimationPlayer.play("FlipHeads")
	else: %AnimationPlayer.play("FlipTails")

func play_flip():
	print(self, position, global_position)
	%FlipAnim.play("Flip")

func flip_tween():
	var flip_tween: Tween = create_tween().set_ease(Tween.EASE_OUT)
	flip_tween.tween_property(self, "position", position - Vector2(0,11), .2)
	flip_tween.set_ease(Tween.EASE_IN)
	flip_tween.tween_property(self, "position", position + Vector2(0,11), .2)

func emit_result():
	shown.emit()
