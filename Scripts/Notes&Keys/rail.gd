extends Line2D
class_name Rail

var Notes : Array[NoteController]

enum NoteButtonType { FIRST, SECOND, THIRD, FORTH }
@export var button_position : NoteButtonType

@export var rail_id : int
@export var note_scene : PackedScene
@export var limits : Node2D

func _ready() -> void:
	var button : NoteButton = get_child(0)
	button.set_button_position(button_position)

func add_note(note : NoteController, speed : float):
	
	add_child(note)
	
	# aquí tienes que hacer que se spawnee la nota, porque
	# desde el otro script se está mandando un int,
	# lo cual tampoco entiendo qué es.
	note.set_rail(self)
	note.set_speed(speed)
	note.set_limits(limits)
	
	Notes.append(note)
	
	# Hay que refactorizar esto
	
	# Notas para mañana:
	# - Tener un método fácil de spawnear notas para que funcione bien por señales
	# - Para eso tenemos que tener un Manager de carriles, al que le digas
	# "spawnNote" y lo genere en un carril aleatorio.
	# - Esa nota la debería gestionar el propio carril y todo eso.
	

func remove_note(note : NoteController):
	Notes.erase(note)
