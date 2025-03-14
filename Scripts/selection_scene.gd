extends Node2D

var texto : String = "Never gonna give you up, Never gonna let you down, Never gonna turn around and desert you Never gonna make you cry Never gonna say goodbye Never gonna tell a lie and hurt you"
var index : int = 0
var done : bool = false
var timer : float = 0
var timePerChar: float = 0.01

var setReady : bool = false
var isReady : bool = false
var player1ReadyArray : Array = [false,false,false,false]
var player1Ready : bool = false
var player2Ready : bool =false
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(GameManager != null):
		texto = GameManager._speech
		$Narrador.texture = GameManager._narrator_image
		$Narrador.scale = Vector2(150,150) / $Narrador.texture.get_size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !done:
		showText(delta)
	else:
		if !setReady:
			$Regadera.visible=true
			$Matamoscas.visible=true
			setReady=true
		elif !isReady:
			if player1Ready && player2Ready:
				$Button2.visible=true
				isReady=true

func _input(event: InputEvent) -> void: 
	if event.is_action_pressed("note_button_first"):
		player1ReadyArray[0]=true
	elif event.is_action_pressed("note_button_second"):
		player1ReadyArray[1]=true
	elif event.is_action_pressed("note_button_third"):
		player1ReadyArray[2]=true
	elif event.is_action_pressed("note_button_forth"):
		player1ReadyArray[3]=true
	var ready : bool = true 	
	for b in player1ReadyArray:
		ready = ready && b
	if ready:
		$Regadera.self_modulate.a=255
		player1Ready=true		
		

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


func Player2Ready() -> void:
	$Matamoscas/MatamoscasImg.self_modulate.a=255
	player2Ready=true
