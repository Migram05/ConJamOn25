extends Node2D

var node := get_parent();

@onready var wander := find_child("Wander", false, true);
@onready var noteDetector := find_child("NoteDetector", false, true);

var wandering := true;

@export var plantPosition : Vector2;
@export var attachToNoteProbability := 0.25;
@export var timeToAttatchToTree := 1.0;
@export var sprite : Sprite2D;


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
			wandering = false;
			wander.stop();
			attatchedToTree = true;
			if (plantNode != null):
				plantNode.addFly();
	sprite.rotation = lerpf(sprite.rotation, wander.total_speed.angle(), 0.01);
	
	noteColliding = false;
	return;

func onNoteCollision(note):
	if (wandering && rng.randf_range(0.0, 1.0) < attachToNoteProbability):
		wandering = false;
		wander.stop();
		noteColliding = true;
		note.fly_block();
		noteAttatched = note;
		owner.get_parent().remove_child(owner);
		owner.scale = owner.scale / noteAttatched.global_scale;
		noteAttatched.add_child(owner);
		owner.position = Vector2.ZERO;
		noteDetector.queue_free();
		

func onFlyDestroyed():
	if (noteAttatched != null):
		noteAttatched.fly_free();
	if (attatchedToTree && plantNode != null):
		plantNode.removeFly();
	return;

func _exit_tree():
	onFlyDestroyed();
