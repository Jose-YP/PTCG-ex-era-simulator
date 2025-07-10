@icon("res://Art/Coins/BreloomFirst.png")
extends Control

@export var coin_heads: CompressedTexture2D = load("res://Art/Coins/BreloomFirst.png")
@export var offset: Vector2 = Vector2(0,-12)

@onready var flip_anim: AnimatedSprite2D = %FlipAnim
@onready var heads: TextureRect = %Heads
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var result: bool

signal shown

func _ready() -> void:
	heads.texture = coin_heads

func play_result():
	if result: %AnimationPlayer.play("FlipHeads")
	else: %AnimationPlayer.play("FlipTails")

func play_flip():
	%FlipAnim.play("Flip")
	toss()

func toss():
	var flip_tween: Tween = create_tween().\
	set_ease(Tween.EASE_OUT).set_speed_scale(animation_player.speed_scale)
	
	flip_tween.tween_property(flip_anim, "position", flip_anim.position - Vector2(0,32), .35)
	flip_tween.set_ease(Tween.EASE_IN)
	flip_tween.tween_property(flip_anim, "position", flip_anim.position, .15)

func emit_result():
	shown.emit()

func reset():
	%AnimationPlayer.play("RESET")
