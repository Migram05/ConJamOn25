class_name NoteButton
extends Node2D

enum NoteButtonType {FIRST, SECOND, THIRD, FORTH }

@export var buttonPosition : NoteButtonType

@export var pressedFeedback : PackedScene

var action : Array[String] = ["note_button_first", "note_button_second",
"note_button_third", "note_button_forth"]

func _input(event: InputEvent) -> void: 
	if event.is_action_pressed(action[buttonPosition]):
		var instance = pressedFeedback.instantiate()
		add_child(instance)
		var key_rotation : float = 0
		
		match buttonPosition:
			NoteButtonType.FIRST:
				key_rotation = 3 * PI / 2
			NoteButtonType.SECOND:
				key_rotation = 0
			NoteButtonType.THIRD:
				key_rotation = PI
			NoteButtonType.FORTH:
				key_rotation = PI / 2
			_:
				key_rotation = 0
		
		instance.set_rotation(key_rotation)
		
		print(key_rotation)
