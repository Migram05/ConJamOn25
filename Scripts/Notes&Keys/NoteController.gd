extends Area2D
class_name NoteController

#Velocidad de la nota bajando por el carril
@export var distanceLabels : Array[float]
@export var feedbackSprites : Array[Texture2D]
@export var missSprite : Texture2D
@export var floatingText : PackedScene
@export var perfect_particles : PackedScene
@export var note_fade_out_time : float = 0.2

var rail : Rail
var limit : Node2D
var speed : float
var blocked_by_fly : bool
var move : bool = true

enum NotePrecision { MISSED = 0, BAD = 1, GOOD = 2, PERFECT = 3 }
signal note_clicked(precision : NotePrecision)
@onready var timer: Timer = $Timer

#Posicion y en la que va a desaparecer la nota y fallarse
func _process(delta):
	if move:
		global_position.y += delta * speed
	
	if limit.position.y < position.y:
		delete_note(0)
		print("webo")

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
			category = n + 1
	
	delete_note(category)

func delete_note(category : int):
	move = false
	
	var instance : Sprite2D = floatingText.instantiate()
	rail.precisionLabelSpawnpoint.add_child(instance)
	
	if category == 0:
		instance.texture = missSprite
	else:
		instance.texture = feedbackSprites[category - 1]
		if category == NotePrecision.PERFECT:
			var particles_instance = perfect_particles.instantiate()
			instance.add_child(particles_instance)
			var particles : GPUParticles2D = particles_instance
			particles.emitting = true

	var precision : NotePrecision = category
	note_clicked.emit(precision)
	 
	$CollisionShape2D.set_deferred("disabled", true)
	
	rail.remove_note(self)
	$GPUParticles2D.emitting
	fade_out(note_fade_out_time)

func fade_out(time_to_live):
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0, time_to_live)
	tween.play()
	await tween.finished
	tween.kill()
	queue_free()


func fly_block():
	blocked_by_fly = true

func fly_free():
	blocked_by_fly = false
