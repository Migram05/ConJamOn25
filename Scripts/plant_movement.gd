extends Node2D

@onready var sprite : Node2D = find_child("Sprite2D");

@export var fliesToStopGrowth := 5;
@export var flyGrowthDecrement := 0.8;
@export var perfectGrowth := 4.0;
@export var goodGrowth := 2.0;
@export var badGrowth := 0.5;
@export var upSpeed := 3.0;

var targetPosition := 0.0;
var currentFlies := 0;

enum NotePrecision { MISSED, BAD, GOOD, PERFECT }

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
	match(precision):
		NotePrecision.BAD:
			targetPosition += badGrowth;
		NotePrecision.GOOD:
			targetPosition += goodGrowth;
		NotePrecision.PERFECT:
			targetPosition += perfectGrowth;
		
