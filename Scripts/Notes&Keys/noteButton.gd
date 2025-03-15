class_name NoteButton
extends Node2D

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
		
		match button_position:
			Rail.NoteButtonType.FIRST:
				key_rotation = 3 * PI / 2
			Rail.NoteButtonType.SECOND:
				key_rotation = 0
			Rail.NoteButtonType.THIRD:
				key_rotation = PI
			Rail.NoteButtonType.FORTH:
				key_rotation = PI / 2
			_:
				key_rotation = 0
		
		instance.get_child(0).set_rotation(key_rotation)
