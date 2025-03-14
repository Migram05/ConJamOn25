extends Node2D
class_name PressedKeyFeedback

@export var time_to_live : float

var key_rotation : float = 0

@export var sprite : Sprite2D

func _ready():
	# Add a timer to this node
	get_tree().create_timer(time_to_live, false, true, false).timeout.connect(queue_free)
	fade_out()

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate:a", 0, time_to_live)
	tween.play()
	await tween.finished
	tween.kill()
