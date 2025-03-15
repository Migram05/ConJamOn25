extends Node2D

@onready var sprite : Node2D = find_child("Sprite2D");
var levelLenght

@export var fliesToStopGrowth := 5;
@export var flyGrowthDecrement := 0.8;
@export var perfectGrowth := 1.0;
@export var goodGrowth := 0.5;
@export var badGrowth := 0.25;
@export var upSpeed := 3.0;
@export var maxPlantScroll := 50.0;

var targetPosition := 0.0;
var currentFlies := 0;
var noteGrowth;

enum NotePrecision { MISSED, BAD, GOOD, PERFECT }

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

func removeFly():
	--currentFlies;

func _on_note_clicked(precision : NotePrecision):
	var flyGrowth = 1 - currentFlies * flyGrowthDecrement; 
	match(precision):
		NotePrecision.BAD:
			targetPosition += badGrowth * noteGrowth * flyGrowth;
		NotePrecision.GOOD:
			targetPosition += goodGrowth * noteGrowth * flyGrowth;
		NotePrecision.PERFECT:
			targetPosition += perfectGrowth * noteGrowth * flyGrowth;
		
