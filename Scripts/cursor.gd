class_name GameCursor
extends RigidBody2D

const MAX_ELEMENTS = 5
var currentTargets : Array[Node2D]
var cont : int = 0
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var smashSound : FmodEventEmitter2D
@export var smashFlySound : FmodEventEmitter2D

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
			var distanceNormalized = check_distance(node)
			if node.pressed(distanceNormalized, $"."):
				remove_element(node)
				smashFlySound.play_one_shot()
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			smashSound.play_one_shot()
func get_radius() -> float:
	return collision_shape_2d.shape.get_rect().size.x
	
func check_distance(node : Target) -> float:
	var distance = ((node.get_node("AnimationNode").global_position - global_position).length() + get_radius()) / node.get_radius()
	distance = clamp(distance, 1, 2)
	distance = 1 / distance
	return distance
