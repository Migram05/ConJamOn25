extends Node2D
class_name PressedKeyFeedback

@export var time_to_live : float
@export var sprite : Sprite2D

var button_type : Rail.NoteButtonType

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
