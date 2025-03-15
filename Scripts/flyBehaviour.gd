extends Node2D

var node := get_parent();

var wander := find_child("Wander", false, true);
var plant := find_child("Plant", false, true);

var wandering := true;

var currentState := wander;

@export var plantPosition : Vector2;
@export var attachToNoteProbability := 0.25;
@export var timeToAttatchToTree := 1.0;

var timeWandering := 0.0;

var noteColliding := false;
var rng = RandomNumberGenerator.new();

var noteAttatched : Area2D = null;

func changeState(state: Node2D):
	currentState.stop();
	currentState = state;
	currentState.play();

func _ready():
	wander = find_child("Wander", false, true);
	plant = find_child("Plant", false, true);
	wander.setPlantPosition(plantPosition);
	currentState = wander;
	currentState.play();

func transition_to_tree() -> bool:
	return timeWandering >= timeToAttatchToTree;


func _process(delta):
	timeWandering += delta;
	if (wandering && transition_to_tree()):
			changeState(plant);
	
	noteColliding = false;
	return;

func onNoteCollision(note):
	if(rng.randf_range(0.0, 1.0) > attachToNoteProbability):
		changeState(note);
		noteColliding = true;
		note.fly_block();
		noteAttatched = note;

func onFlyDestroyed():
	if (noteAttatched != null):
		noteAttatched.fly_unblock();
	return

func _exit_tree():
	onFlyDestroyed();
