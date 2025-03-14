class_name Target
extends Node2D

@onready var timer: Timer = $Timer

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

func setTimers(timeOpened, timeToBeOpened, timeClosed):
	timer.stop()
	timeOpen = timeOpened
	timeToOpen = timeToBeOpened
	timeClose = timeClosed
	timer.wait_time = timeOpen
	timer.start()

func _ready() -> void:
	timer.wait_time = timeOpen
	timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Enter")
	var cursor : GameCursor = body
	cursor.insert_element($".")
	cursorOn = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	print("Exit")
	var cursor : GameCursor = body
	cursor.remove_element($".")
	cursorOn = false
	
func pressed(distanceNormalized, cursor) -> bool:
	gameCursor = cursor
	match enemyState:
		State.CLOSED:
			print("Closed")
			return false
		State.OPENING:
			score = (timeToOpen - timer.time_left) *  scoreMultiplier
			print("Opening")
			
		State.OPEN:
			score = timeOpen *  scoreMultiplier
			print("Open")
			
		State.CLOSING:
			score = timer.time_left *  scoreMultiplier
			print("Closing")
			
	print("Score: " + str(score))
	distance = distanceNormalized
	timer.stop()
	_click()
	return true


func _on_timer_timeout() -> void:
	match enemyState:
		State.CLOSED:
			enemyState = State.OPENING
			timer.wait_time = timeToOpen
		State.OPENING:
			enemyState = State.OPEN
			timer.wait_time = timeOpen
		State.OPEN:
			enemyState = State.CLOSING
			timer.wait_time = timeToOpen	
		State.CLOSING:
			enemyState = State.CLOSED
			timer.wait_time = timeClose
	timer.start()
	
	
func get_radius() -> float:
	return collision_shape_2d.shape.get_rect().size.x
	
func reset():
	timer.wait_time = timeClose
	enemyState = Target.State.CLOSED
	timer.start()
	
# Cosas especificas del target
func _click():
	score = score * distance
	queue_free()
	
