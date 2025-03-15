extends Area2D
class_name NoteController

#Velocidad de la nota bajando por el carril
@export var distanceLabels : Array[float]
@export var labelTexts : Array[String]
@export var floatingText : PackedScene

var rail : Rail
var limit : Node2D
var speed : float

#Posicion y en la que va a desaparecer la nota y fallarse
func _process(delta):
	position.y += delta * speed
	
	if limit.position.y < position.y:
		delete_note()

func set_limits(limits : Node2D):
	limit = limits
	
func set_rail(_rail : Rail):
	rail = _rail

func set_speed(_speed : float):
	speed = _speed

func player_hits_key(otherNode : Node2D):
	if otherNode.button_type != rail.button_position:
		return
	
	var instance : Label = floatingText.instantiate()
	var diff : Vector2 = otherNode.global_position - global_position
	var distance : float = diff.length()
	
	var category : int = 0
	
	for n : int in distanceLabels.size():
		if distance <= distanceLabels[n]:
			category = n
	
	instance.text = labelTexts[category]
	
	otherNode.get_parent().add_child(instance)
	instance.rotation = 0
	
	delete_note()

func delete_note():
	rail.remove_note(self)
	queue_free()

func block():
	return
