extends Node

#Prefab de la nota
@export var nota: PackedScene 
#Boton del carril
@export var button: Button

# Spawnea la nota en el punto de spawn y conecta la senial del boton a la funcion de la nota
func spawnNote(note):
	var newNote = nota.instantiate()
	add_child(newNote)
	button.pressed.connect(newNote._on_boton_pressed)
