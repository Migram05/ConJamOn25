class_name NoteSpawner
extends Node

#Contador de tiempo
var timer = 0
#Indice del array actual
var currentIndex : int  = 0
#Indice maximo de puntos de spawn
var maxIndex = 0

@export var note_speed : float
#Tiempo en el que van a aparecer las notas
@export var noteStamps : Array[float] = []
@export var nota: PackedScene 
@export var rails : Array[Node2D]

func _ready():
	maxIndex = rails.size()-1

# Avanza un timer que recorre noteStamps y las va spawneando en las cuerdas de forma aleatoria
# en su tiempo correspondiente al llegar al final vuelve al inicio de las notas
func _process(delta):
	pass
	#timer += delta
	#if(noteStamps[currentIndex] < timer):
		#var chosen_rail = randi_range(0,maxIndex)
		#spawnNote(chosen_rail, note_speed)
		#if(currentIndex + 1 == noteStamps.size()):
			#currentIndex = 0
			#timer = 0
		#else:
			#currentIndex += 1

# Spawnea la nota en el punto de spawn y conecta la senial del boton a la funcion de la nota
func spawnNote(chosen_rail, speed):
	rails[chosen_rail].add_note(nota.instantiate(), speed)
