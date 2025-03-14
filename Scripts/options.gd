extends Node

 # Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Volume/VolumeText.text = str(GameManager._volume)
	$Volume/VolumeSlider.value = GameManager._volume

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func GoBackToMenu() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.MAIN_MENU);


func ChangeVolume(value: float) -> void:
	GameManager._volume = value
	$Volume/VolumeText.text = str(GameManager._volume)


func FullScreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
