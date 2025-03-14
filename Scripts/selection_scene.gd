extends Node2D

var texto : String = "Never gonna give you up, Never gonna let you down, Never gonna turn around and desert you Never gonna make you cry Never gonna say goodbye Never gonna tell a lie and hurt you"
var index : int = 0
var done : bool = false
var timer : float = 0
var timePerChar: float = 0.05
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !done:
		showText(delta)

func showText(delta : float) -> void:
	if index < texto.length():
		if timer > timePerChar:
			$Label.text += texto[index]
			index+=1
			timer=0
		timer += delta
	else:
		done=true

func GoBack() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.LAB_MENU);


func Play() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.GAME_LEVEL);
