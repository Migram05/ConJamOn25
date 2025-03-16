extends Node2D

var pressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func GoToLab() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.LAB_MENU);


func GoToOptions() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.OPTIONS);


func Exit() -> void:
	get_tree().quit()


func HoverPlay() -> void:
	if !pressed:
		$AnimatedSprite2D.play("over")


func LeftPlay() -> void:
	if !pressed:
		$AnimatedSprite2D.play("left")

func PlayUp() -> void:
	$Timer.start()
	
func PlayPress() -> void:
	pressed = true
	$Button2/Sprite2D.visible=false
	$Button2/EmptyCircle.visible=false
	$AnimatedSprite2D.scale.x = -1*$AnimatedSprite2D.scale.x
	$AnimatedSprite2D.play("press")


func Credits() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.CREDITS);
