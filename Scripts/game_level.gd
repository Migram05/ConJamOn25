extends Node2D
class_name GameLevel

@onready var minijuego_piano_tiles : NoteSpawner = $MinijuegoPianoTiles

var timesNotes : Array[float]
var index = 0
var timeUntilPerfect = 0
const START_TIME = 3
var initial_timer = 0
var spawn_timer = 0
var spawn_max_timer = 0
var started = false
var have_more_notes = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager != null:
		var distance = minijuego_piano_tiles.rails[0].get_node("Tecla").global_position.y - minijuego_piano_tiles.rails[0].get_node("Spawnpoint").global_position.y 
		timeUntilPerfect = distance / minijuego_piano_tiles.note_speed
		_process_notes()
		print(timesNotes.size())
		spawn_max_timer = START_TIME + timesNotes[0] - timeUntilPerfect
		

func _input(event: InputEvent) -> void: 
	if event.is_action_pressed("pause"):
		SceneManager.pauseScene(true)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Label.text +=str(1)
	initial_timer += delta
	spawn_timer += delta
	if not started and initial_timer >= START_TIME:
		GameManager._play_song()
		started = true
	
	if spawn_timer >= spawn_max_timer and have_more_notes:
		_next_note(spawn_timer - spawn_max_timer)
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
		

func _next_note(spawnDiff):
	var chosen_rail = randi_range(0,minijuego_piano_tiles.maxIndex)
	var note = minijuego_piano_tiles.spawnNote(chosen_rail, minijuego_piano_tiles.note_speed)
	note.global_position.y += minijuego_piano_tiles.note_speed * spawnDiff
	var last_note = timesNotes[index]
	index += 1
	if index < timesNotes.size():
		spawn_max_timer = timesNotes[index] - last_note
		last_note = timesNotes[index]
		spawn_timer = spawnDiff
		print(spawn_timer)
	else:
		have_more_notes = false
		#timer.wait_time = timesNotes[index] - current_time
		# index += 1
		#current_time += timer.wait_time
		#timer.start()
