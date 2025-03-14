extends Node

@export var raycast : RayCast2D

func _physics_process(delta: float) -> void:
	if raycast.is_colliding():
		raycast.get_collider().player_hits_key(self.get_parent())
		raycast.enabled = false
