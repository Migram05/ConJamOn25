extends Node2D

@export var pot : Node2D;
@export var segments : Array[PackedScene];
@export var offset := 20.0;

@onready var lastSegment := pot;

var rng = RandomNumberGenerator.new();

func spawn():
	var segment : PlantSegmentAnimator = segments[rng.randi_range(0, segments.size() - 1)].instantiate();
	var y = owner.global_position.y - lastSegment.texture.get_size().y / 2.0 - segment.glow.texture.get_size().y / 2.0 + offset;
	self.add_child(segment);
	segment.global_position.y = y;
	lastSegment = segment.glow;

func _process(delta):
	if (lastSegment.global_position.y > 50):
		spawn();
