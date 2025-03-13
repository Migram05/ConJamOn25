extends Area2D

#Velocidad de la nota bajando por el carril
const SPEED = 100

#Posicion y en la que va a desaparecer la nota y fallarse
const DEATH_ZONE = 800

#Se desplaza la nota, hacia abajo y si baja de la death zone se elimina
func _process(delta):
	position.y += delta * SPEED
	if (position.y> DEATH_ZONE):
		queue_free();
	

#Funcion conectada al boton de su carril, al apretarse el boton si las areas estan una encima de
#la otra se elimina
func _on_boton_pressed():
	if(get_overlapping_areas().size()>0):
		queue_free();
