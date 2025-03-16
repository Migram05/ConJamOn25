extends Node2D

@onready var wander := find_child("Wander", false, true);
@onready var noteDetector := find_child("NoteDetector", false, true);

var wandering := true;

@export var plantPosition : Vector2;
@export var attachToNoteProbability := 0.25;
@export var timeToAttatchToTree := 1.0;
@export var sprite : Node2D;
@export var animation : AnimatedSprite2D;
@export var flyAttackAnimation : String;

var plantNode : Node2D;

var timeWandering := 0.0;

var noteColliding := false;
var rng = RandomNumberGenerator.new();

var noteAttatched : NoteController = null;
var attatchedToTree := false;

func _ready():
	wander.setPlantPosition(plantPosition);
	wander.play();
	owner.rotation = (Vector2.RIGHT.rotated(wander.rotation) * wander.forwardSpeed).angle();

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
			var current_frame = animation.frame
			animation.animation = flyAttackAnimation;
			animation.frame = current_frame
	sprite.rotation = lerpf(sprite.rotation, wander.total_speed.angle(), 0.02);
	noteColliding = false;
	return;

func onNoteCollision(note):
	if (wandering && rng.randf_range(0.0, 1.0) < attachToNoteProbability):
		wandering = false;
		owner.get_parent().remove_child(owner);
		wander.stop();
		noteColliding = true;
		note.fly_block();
		noteAttatched = note;
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
