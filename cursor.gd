class_name GameCursor
extends RigidBody2D

const MAX_ELEMENTS = 5
var currentTargets : Array[Node2D]
var cont : int = 0

func _ready():
	currentTargets.resize(MAX_ELEMENTS)
	currentTargets.fill(null)
	
func insert_element(elem : Node2D):
	if cont >= MAX_ELEMENTS: 
		return
	
	var i = 0
	while(i < MAX_ELEMENTS and currentTargets[i] != null and currentTargets[i].z_index <= elem.z_index):
		i += 1
	
	if i < MAX_ELEMENTS:
		if(currentTargets[i] != null):
			var j = MAX_ELEMENTS - 1
			while j >= i:
				currentTargets[j] = currentTargets[j - 1]
				j -= 1
		currentTargets[i] = elem
		cont += 1
		
func remove_element(elem : Node2D):
	var i = 0
	while(i < MAX_ELEMENTS and currentTargets[i] != null and currentTargets[i] != elem):
		i += 1
	
	if i < MAX_ELEMENTS and currentTargets[i] == elem:
		while i + 1 < MAX_ELEMENTS:
			currentTargets[i] = currentTargets[i + 1]
			i += 1
		currentTargets[i] = null
		cont -= 1

func _input(event):
	if event is InputEventMouseMotion:
		position = get_viewport().get_camera_2d().get_global_mouse_position()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and cont > 0:
			var node : Target = currentTargets[cont - 1]
			if node.pressed():
				remove_element(node)
			
