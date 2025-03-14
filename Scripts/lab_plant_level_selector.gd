class_name LevelPlant
extends Node2D

var displayName : String:
	set(new_text):
		displayName = new_text
		$Button.text = new_text.to_upper()
				
var lastScore : String:
	set(new_text):
		lastScore = new_text
		$Button/LastScoreLabel.text = "Last Score: " + new_text

var song_file_path : String
var events_file_path : String

func _on_button_pressed() -> void:
	var sample := load(song_file_path)
	if(sample != null):
		$AudioStreamPlayer2D.stream = sample
		$AudioStreamPlayer2D.play()
		if GameManager._volume<1:
			$AudioStreamPlayer2D.volume_db = -1000
		else:
			$AudioStreamPlayer2D.volume_db = -40 + GameManager._volume * 40 /100
	print("Starting song " + displayName)


func GoToHistorial() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.HISTORIAL_MENU);


func GoToSelection() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.SELECTION_MENU);
