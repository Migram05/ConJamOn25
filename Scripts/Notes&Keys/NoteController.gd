extends Area2D

#Velocidad de la nota bajando por el carril
const SPEED = 100

#Posicion y en la que va a desaparecer la nota y fallarse
func _process(delta):
	position.y += delta * SPEED
