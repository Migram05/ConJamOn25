extends Node2D
@export var score_display : PackedScene 

func _ready() -> void:
	$Titulo.text = GameManager._current_level_name
	$Label2.text = GameManager._score_content
		
func _on_button_pressed() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.LAB_MENU);
