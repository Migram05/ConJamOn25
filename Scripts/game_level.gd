extends Node2D

@onready var minijuego_piano_tiles: NoteSpawner = $MinijuegoPianoTiles

@onready var initial_timer: Timer = $InitialTimer
@onready var spawn_timer: Timer = $SpawnTimer
var timesNotes : Array[float]
var index = 0
var timeUntilPerfect = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager != null:
		var distance = minijuego_piano_tiles.rails[0].get_node("Spawnpoint").global_position.y - minijuego_piano_tiles.rails[0].get_node("Tecla").global_position.y
		timeUntilPerfect = abs(distance) / minijuego_piano_tiles.note_speed
		_process_notes()
		spawn_timer.wait_time = initial_timer.wait_time + (timesNotes[0] - timeUntilPerfect)
		print(spawn_timer.wait_time)
		spawn_timer.start()
		

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
			timesNotes.push_back(((float)(numbers[i].split("\t")[0])))
		
	
	
func _next_note():
	var last_note = timesNotes[index]
	index += 1
	if index < timesNotes.size():
		spawn_timer.wait_time = timesNotes[index] - last_note
		last_note = timesNotes[index]
		spawn_timer.start()

func _on_initial_timer_timeout() -> void:
	GameManager._play_song()


func _on_spawn_timer_timeout() -> void:
	var chosen_rail = randi_range(0,minijuego_piano_tiles.maxIndex)
	minijuego_piano_tiles.spawnNote(chosen_rail, minijuego_piano_tiles.note_speed)
	_next_note()
