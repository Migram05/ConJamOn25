extends Line2D
class_name Rail

var Notes : Array[NoteController]

enum NoteButtonType { FIRST, SECOND, THIRD, FORTH, NONE }
@export var button_position : NoteButtonType
@export var note_scale : float

@export var note_scene : PackedScene
@export var limits : Node2D
@export var precisionLabelSpawnpoint : Node2D

func _ready() -> void:
	var button : NoteButton = get_child(0)
	button.set_button_position(button_position)

func add_note(note : NoteController, speed : float):
	add_child(note)
	
	note.scale = Vector2(note_scale, note_scale)

	note.set_rail(self)
	note.set_speed(speed)
	note.set_limits(limits)
	
	Notes.append(note)

func remove_note(note : NoteController):
	Notes.erase(note)
