extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager != null:
		GameManager._play_song()

func GoToLab() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.LAB_MENU);
	if GameManager != null:
		GameManager._stop_song()
