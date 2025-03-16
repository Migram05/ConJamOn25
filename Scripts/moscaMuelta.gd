extends AnimatedSprite2D

func _on_animation_finished():
	owner.queue_free()
