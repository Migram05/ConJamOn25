extends Node2D

@onready var minijuego_piano_tiles: NoteSpawner = %MinijuegoPianoTiles

@onready var initial_timer: Timer = $InitialTimer
@onready var spawn_timer: Timer = $SpawnTimer
var timesNotes : Array[float]
var index = 0
var current_time = 0
var timeUntilPerfect = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager != null:
		_process_notes()
		GameManager._play_song()
		_next_note()
		var distance = minijuego_piano_tiles.spawnPoints[0].global_position.y - minijuego_piano_tiles.rails[0].get_node("Tecla").global_position.y
		

func _input(event: InputEvent) -> void: 
	if event.is_action_pressed("pause"):
		SceneManager.pauseScene(true)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Label.text +=str(1)
	pass

func GoToLab() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.LAB_MENU);
	if GameManager != null:
		GameManager._stop_song()
		
		
func _process_notes() -> void:
	if GameManager != null:
		var file : String = GameManager._notes
		var numbers = file.split("\n")
		for i in numbers.size() - 1:
			timesNotes.push_back((float)(numbers[i].split("\t")[0]))
		


func _on_timer_timeout() -> void:
	_next_note()
	
	
	
func _next_note():
	if index < timesNotes.size():
		#timer.wait_time = timesNotes[index] - current_time
		$Label.text +=str(1)
		index += 1
		#current_time += timer.wait_time
		#timer.start()


func _on_initial_timer_timeout() -> void:
	pass # Replace with function body.
