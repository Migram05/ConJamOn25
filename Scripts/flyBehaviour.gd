extends Node2D

var node := get_parent();

@onready var wander := find_child("Wander", false, true);

var wandering := true;

@export var plantPosition : Vector2;
@export var attachToNoteProbability := 0.25;
@export var timeToAttatchToTree := 1.0;

@onready var plantNode = owner.get_parent().get_node("Plant");

var timeWandering := 0.0;

var noteColliding := false;
var rng = RandomNumberGenerator.new();

var noteAttatched : Area2D = null;
var attatchedToTree := false;

func _ready():
	wander.setPlantPosition(plantPosition);
	wander.play();

func transition_to_tree() -> bool:
	return timeWandering >= timeToAttatchToTree;


func _process(delta):
	timeWandering += delta;
	if (wandering && transition_to_tree()):
			wander.stop();
			attatchedToTree = true;
			if (plantNode != null):
				plantNode.addFly();
	
	noteColliding = false;
	return;

func onNoteCollision(note):
	if(rng.randf_range(0.0, 1.0) > attachToNoteProbability):
		wander.stop();
		noteColliding = true;
		note.fly_block();
		noteAttatched = note;

func onFlyDestroyed():
	if (noteAttatched != null):
		noteAttatched.fly_free();
	if (attatchedToTree && plantNode != null):
		plantNode.removeFly();
	return;

func _exit_tree():
	onFlyDestroyed();
