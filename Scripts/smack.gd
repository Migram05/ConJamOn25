class_name Smack
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
const SMACK_PERFECT = preload("res://Assets/Sprites/smackPerfect.png")

func setPerfect():
	sprite_2d.texture = SMACK_PERFECT

func _process(delta: float) -> void:
	sprite_2d.self_modulate.a = timer.time_left / timer.wait_time

func _on_timer_timeout() -> void:
	queue_free()
