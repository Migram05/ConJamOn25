extends Node2D
class_name NoteButton

@export var pressedFeedback : PackedScene

var action : Array[String] = ["note_button_first", "note_button_second",
"note_button_third", "note_button_forth"]

var button_position : Rail.NoteButtonType

func set_button_position(pos : Rail.NoteButtonType):
	button_position = pos

func _input(event: InputEvent) -> void: 
	if event.is_action_pressed(action[button_position]):
		var instance = pressedFeedback.instantiate()
		add_child(instance)
		var key_rotation : float = 0
		
		instance.button_type = button_position
