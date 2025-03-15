extends Area2D
class_name NoteController

#Velocidad de la nota bajando por el carril
@export var distanceLabels : Array[float]
@export var feedbackSprites : Array[Texture2D]
@export var missSprite : Texture2D
@export var floatingText : PackedScene

var rail : Rail
var limit : Node2D
var speed : float
var blocked_by_fly : bool

enum NotePrecision { MISSED, BAD, GOOD, PERFECT }
signal note_clicked(precision : NotePrecision)

#Posicion y en la que va a desaparecer la nota y fallarse
func _process(delta):
	position.y += delta * speed
	
	if limit.position.y < position.y:
		delete_note(-1)

func set_limits(limits : Node2D):
	limit = limits
	
func set_rail(_rail : Rail):
	rail = _rail

func set_speed(_speed : float):
	speed = _speed

func player_hits_key(otherNode : Node2D):
	if otherNode.button_type != rail.button_position && !blocked_by_fly:
		return
	
	var diff : Vector2 = otherNode.global_position - global_position
	var distance : float = diff.length()
	
	var category : int = 0
	
	for n : int in distanceLabels.size():
		if distance <= distanceLabels[n]:
			category = n
	
	delete_note(category)

func delete_note(category : int):
	var instance : Sprite2D = floatingText.instantiate()
	
	if category < 0:
		instance.texture = missSprite
	else:
		instance.texture = feedbackSprites[category]

	var precision : NotePrecision = category
	note_clicked.emit(precision)
	rail.precisionLabelSpawnpoint.add_child(instance)
	
	rail.remove_note(self)
	queue_free()

func fly_block():
	blocked_by_fly = true

func fly_free():
	blocked_by_fly = false
