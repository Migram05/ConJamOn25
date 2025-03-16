class_name Target
extends Node2D

@onready var timer: Timer = $Timer
@onready var bug_generator : BugGenerator = $"../"

enum State { CLOSED, OPENING, OPEN, CLOSING, NUM_STATES}
var timeOpen = 0.2
var timeToOpen = 0.4
var timeClose = 1
var enemyState : Target.State = State.CLOSED
var gameCursor : GameCursor
var score = 0
var distance = 0
var cursorOn = false
@export var scoreMultiplier = 1.0
@onready var collision_shape_2d: CollisionShape2D = $AnimationNode/Area2D/CollisionShape2D

func _ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	var cursor : GameCursor = body
	cursor.insert_element($".")
	cursorOn = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	var cursor : GameCursor = body
	cursor.remove_element($".")
	cursorOn = false
	
	
func changeState(state):
	enemyState = state
	
func pressed(distanceNormalized, cursor) -> bool:
	gameCursor = cursor
	match enemyState:
		State.CLOSED:
			return false
		State.OPENING:
			#score = (timeToOpen - timer.time_left) *  scoreMultiplier
			print("Opening")
		State.OPEN:
			#score = timeOpen *  scoreMultiplier
			print("Open")
		State.CLOSING:
			#score = timer.time_left *  scoreMultiplier
			print("Closing")

	#print("Score: " + str(score))
	distance = distanceNormalized
	_click()
	return true

func get_radius() -> float:
	return collision_shape_2d.shape.get_rect().size.x

func reset():
	pass
	#timer.wait_time = timeClose
	#enemyState = Target.State.CLOSED
	#timer.start()
	
@export var moscaMuelta : PackedScene;

# Cosas especificas del target
func _click():
	score = score * distance
	ScoreRegister.mosca_killed()
	var inst : Node2D = moscaMuelta.instantiate();
	get_parent().add_child(inst);
	inst.global_position = self.global_position;
	queue_free()

func _on_tree_exiting() -> void:
	bug_generator.current_enemies -= 1
