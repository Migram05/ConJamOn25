extends Node
class_name NoteSpawner

#Contador de tiempo
var timer = 0
#Indice del array actual
var currentIndex : int  = 0
#Indice maximo de puntos de spawn
var maxIndex = 0

@export var note_speed : float
#Tiempo en el que van a aparecer las notas
@export var nota: PackedScene 
@export var rails : Array[Node2D]
@export var score_system : ScoreSystem

enum NotePrecision { MISSED, BAD, GOOD, PERFECT }
signal note_clicked(precision : NotePrecision)
var current_notes = 0

func _ready():
	maxIndex = rails.size() - 1

# Avanza un timer que recorre noteStamps y las va spawneando en las cuerdas de forma aleatoria
# en su tiempo correspondiente al llegar al final vuelve al inicio de las notas
func _process(delta):
	pass

# Spawnea la nota en el punto de spawn y conecta la senial del boton a la funcion de la nota
func spawnNote(chosen_rail, speed) -> Node2D:
	var inst = nota.instantiate()
	inst.note_clicked.connect(_on_note_clicked)
	inst.note_clicked.connect(score_system.score_point)
	rails[chosen_rail].add_note(inst, speed)
	current_notes += 1
	return inst

var notes_clicked : int
func _on_note_clicked(precision : NotePrecision):
	note_clicked.emit(precision);
	ScoreRegister.clicked_note(precision)
	notes_clicked += 1
	current_notes -= 1
	var level : GameLevel = owner
	if notes_clicked >= level.timesNotes.size() - 1:
		$FmodEventEmitter2D.play()
		await get_tree().create_timer(3.5).timeout
		SceneManager.loadScene(SceneManager._SCENES_.SCORE_SCENE)
		GameManager._stop_song()
