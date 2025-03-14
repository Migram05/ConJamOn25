class_name Target
extends Node2D

@onready var timer: Timer = $Timer

enum State { CLOSED, OPENING, OPEN, CLOSING, NUM_STATES}
var timeOpen = 0.2
var timeToOpen = 0.4
var timeClose = 1
var enemyState : Target.State = State.CLOSED
@export var scoreMultiplier = 1.0



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
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	print("Exit")
	var cursor : GameCursor = body
	cursor.remove_element($".")
	
func pressed() -> bool:
	var score = 0
	match enemyState:
		State.CLOSED:
			score = 0
			print("Closed")
			return false
		State.OPENING:
			score = (timeToOpen - timer.time_left) *  scoreMultiplier
			print("Opening")
			queue_free()
			
		State.OPEN:
			score = timeOpen *  scoreMultiplier
			print("Open")
			queue_free()
			
		State.CLOSING:
			score = timer.time_left *  scoreMultiplier
			print("Closing")
			queue_free()
			
	print("Score: " + str(score))
	timer.stop()
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
	
