extends Node2D

var _optionsMenu : Node = null
var exit : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if exit:
		var num : int = $Timer.time_left+1
		$CountDown.text = str(num)
	

func _input(event: InputEvent) -> void: 
	if event.is_action_pressed("pause"):
		Continue()
		

func Continue() -> void:
	if !exit:
		exit = true
		$Continue.visible = false
		$Options.visible = false
		$ExitLevel.visible = false
		$Timer.start()


func GoBackToLab() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.LAB_MENU)
	SceneManager.pauseScene(false)
	GameManager._stop_song()
	self.queue_free()


func options() -> void:
	_optionsMenu = preload("res://Scenes/Menus/Options.tscn").instantiate()
	add_child(_optionsMenu)


func StartAgain() -> void:
	SceneManager.pauseScene(false)
