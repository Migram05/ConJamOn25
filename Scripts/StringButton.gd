extends Node

#Prefab de la nota
@export var nota: PackedScene 

# Spawnea la nota en el punto de spawn y conecta la senial del boton a la funcion de la nota
func spawnNote(note):
	var newNote = nota.instantiate()
	add_child(newNote)
