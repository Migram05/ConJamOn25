extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager != null:
		GameManager._play_song()

func _input(event: InputEvent) -> void: 
	if event.is_action_pressed("pause"):
		SceneManager.pauseScene(true)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text +=str(1)

func GoToLab() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.LAB_MENU);
	if GameManager != null:
		GameManager._stop_song()
