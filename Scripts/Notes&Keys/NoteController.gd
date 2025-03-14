extends Area2D
class_name NoteController

#Velocidad de la nota bajando por el carril
@export var speed = 100

@export var distanceLabels : Array[float]

@export var labelTexts : Array[String]

@export var floatingText : PackedScene

var limit : Node2D

#Posicion y en la que va a desaparecer la nota y fallarse
func _process(delta):
	position.y += delta * speed
	
	if limit.position.y < position.y:
		queue_free()

func set_limits(limits : Node2D):
	limit = limits

func player_hits_key(otherNode : Node2D):
	var instance : Label = floatingText.instantiate()
	var diff : Vector2 = otherNode.global_position - global_position
	var distance : float = diff.length()
	
	var category : int = 0
	
	print(distance)
	for n : int in distanceLabels.size():
		if distance <= distanceLabels[n]:
			category = n
	
	instance.text = labelTexts[category]
	
	otherNode.get_parent().add_child(instance)
	instance.rotation = 0
	
	queue_free()

#func _on_body_entered(body: Node2D) -> void:
	#var instance : Label = floatingText.instantiate()
	#
	#var diff : Vector2 = body.global_position - global_position
	#var distance : float = diff.length()
	#
	#var category : int = 0
	#
	#for n : int in distanceLabels.size():
		#if distance <= distanceLabels[n]:
			#category = n
	#
	#instance.text = labelTexts[category]
	#
	#body.get_parent().add_child(instance)
	#instance.rotation = 0
	#
	## body.kill_rigidbody()
	#
	#queue_free()
