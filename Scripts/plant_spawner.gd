extends Node2D

@export var pot : Node2D;
@export var segments : Array[PackedScene];
@export var offset := 20.0;
@export var damageAnimationTime := 0.3;

@onready var lastSegment := pot;

var rng = RandomNumberGenerator.new();

var damaged := false;

func _ready():
	owner.damage.connect(onDamage);

func spawn():
	var segment : PlantSegmentAnimator = segments[rng.randi_range(0, segments.size() - 1)].instantiate();
	var y = owner.global_position.y - lastSegment.texture.get_size().y / 2.0 - segment.glow.texture.get_size().y / 2.0 + offset;
	self.add_child(segment);
	segment.global_position.y = y;
	lastSegment = segment.glow;
	owner.perfect.connect(segment.onPerfect);
	segment.damaged = damaged;
	damageSignal.connect(segment.onDamage);
	setDamage.connect(segment.setDamage);
	idle.connect(segment.setIdle);

signal damageSignal(bool);

func onDamage(damage : bool):
	damaged = damage;
	damageSignal.emit(damage);

var damageActive := true;

func _process(delta):
	if (lastSegment.global_position.y > 50):
		spawn();
	if (damaged):
		if (damageActive):
			process_damage(delta);
		else:
			process_idle(delta);

var damageCounter := 0.0;

func process_damage(delta):
	damageCounter += delta;
	if (damageCounter >= damageAnimationTime):
		damageCounter = 0.0;
		damageActive = false;
		idle.emit();

func process_idle(delta):
	damageCounter += delta;
	if (damageCounter >= damageAnimationTime):
		damageCounter = 0.0;
		damageActive = true;
		setDamage.emit();

signal idle;
signal setDamage;
