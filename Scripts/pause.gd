extends Node2D

var _optionsMenu : Node = null
var exit : bool = false
var isInOptions : bool =false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if exit:
		var num : int = $Timer.time_left+1
		$CountDown.text = str(num)
	if isInOptions && _optionsMenu==null:
		isInOptions=false
	

func _input(event: InputEvent) -> void: 
	if event.is_action_pressed("pause"):
		Continue()
		

func Continue() -> void:
	if !exit && !isInOptions:
		exit = true
		$Play.visible = false
		$Options.visible = false
		$ExitLevel.visible = false
		$Timer.start()


func GoBackToLab() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.LAB_MENU)
	SceneManager.pauseScene(false)
	GameManager._stop_song()
	self.queue_free()


func options() -> void:
	if !isInOptions:
		_optionsMenu = preload("res://Scenes/Menus/Options.tscn").instantiate()
		add_child(_optionsMenu)
		isInOptions = true


func StartAgain() -> void:
	SceneManager.pauseScene(false)
