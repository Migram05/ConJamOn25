class_name NoteSpawner
extends Node

#Contador de tiempo
var timer = 0
#Indice del array actual
var currentIndex : int  = 0
#Indice maximo de puntos de spawn
var maxIndex = 0

#Puntos de spawn de las notas
@export var spawnPoints: Array[Marker2D] = []
#Array con strings de las notas
@export var notes : Array[int] = []
#Tiempo en el que van a aparecer las notas
@export var noteStamps : Array[float] = []

@export var nota: PackedScene 

@export var limits : Node2D

@export var rails : Array[Node2D]

func _ready():
	maxIndex = spawnPoints.size()-1

# Avanza un timer que recorre noteStamps y las va spawneando en las cuerdas de forma aleatoria
# en su tiempo correspondiente al llegar al final vuelve al inicio de las notas
func _process(delta):
	timer += delta
	if(noteStamps[currentIndex] < timer):
		var chosen = randi_range(0,maxIndex)
		spawnNote(chosen, notes[currentIndex])
		if(currentIndex + 1 == noteStamps.size() || currentIndex + 1 == notes.size()):
			currentIndex = 0
			timer = 0
		else:
			currentIndex += 1

# Spawnea la nota en el punto de spawn y conecta la senial del boton a la funcion de la nota
func spawnNote(chosen, note):
	var newNote = nota.instantiate()
	rails[chosen].add_child(newNote)
	
	newNote.set_limits(limits)
