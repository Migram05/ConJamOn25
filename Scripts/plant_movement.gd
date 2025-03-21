extends Node2D

@export var sprite : Node2D;
var levelLenght

@export var fliesToStopGrowth := 5;
@export var flyGrowthDecrement := 0.8;
@export var perfectGrowth := 1.0;
@export var goodGrowth := 0.5;
@export var badGrowth := 0.25;
@export var upSpeed := 0.05;
@export var maxPlantScroll := 50.0;

var targetPosition := 0.0;
var currentFlies := 0;
var noteGrowth;

enum NotePrecision { MISSED, BAD, GOOD, PERFECT }

signal perfect;
signal damage(bool);

func _ready():
	var gl = find_parent("GameLevel");
	await gl.ready;
	levelLenght = gl.timesNotes.size();
	noteGrowth = maxPlantScroll / levelLenght;

func _process(delta):
	if (currentFlies >= fliesToStopGrowth):
		return;
	sprite.position.y = lerpf(sprite.position.y, targetPosition, upSpeed);
	return;

func addFly():
	++currentFlies;
	damage.emit(true);

func removeFly():
	--currentFlies;
	if (currentFlies == 0):
		damage.emit(false);

func _on_minijuego_piano_tiles_note_clicked(precision: NoteSpawner.NotePrecision) -> void:
	var flyGrowth = 1 - currentFlies * flyGrowthDecrement; 
	match(precision):
		NotePrecision.BAD:
			targetPosition += badGrowth * noteGrowth * flyGrowth;
		NotePrecision.GOOD:
			targetPosition += goodGrowth * noteGrowth * flyGrowth;
		NotePrecision.PERFECT:
			perfect.emit();
			targetPosition += perfectGrowth * noteGrowth * flyGrowth;
