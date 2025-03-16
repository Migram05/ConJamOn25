extends Node2D
@export var score_display : PackedScene 
var back :bool = false
func _ready() -> void:
	$Node2D/Titulo.text = GameManager._current_level_name
	$Node2D/Label2.text = GameManager._score_content
		
func _on_button_pressed() -> void:
	if !back:
		$Node2D/AnimationPlayer.play("back")
		$Timer.start()
		back=true
	
func GoBack() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.LAB_MENU);
	
