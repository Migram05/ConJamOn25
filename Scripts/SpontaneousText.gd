extends Sprite2D

@export var time_to_live : float
@export var speed : float

func _ready():
	# Add a timer to this node
	get_tree().create_timer(time_to_live, false, true, false).timeout.connect(queue_free)
	fade_out()

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, time_to_live)
	tween.play()
	await tween.finished
	tween.kill()

func _process(delta: float) -> void:
	position.y += delta * speed
