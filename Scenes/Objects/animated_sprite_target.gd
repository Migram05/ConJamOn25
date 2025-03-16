extends AnimatedSprite2D
@onready var target: Target = $"../.."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_frame_changed() -> void:
	if frame < 2 or frame >= 18:
		target.changeState(Target.State.CLOSED)
	elif frame < 8:
		target.changeState(Target.State.OPENING)
	elif frame < 12:
		target.changeState(Target.State.OPEN)
	elif frame < 18:
		target.changeState(Target.State.CLOSING)
	print(target.enemyState)
