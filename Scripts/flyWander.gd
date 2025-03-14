extends Node2D

var paused := true;

var plantPosition : Vector2
var target : Vector2

@export var forwardSpeed := 1.0;
@export var amplitude := 100.0;
@export var oscilationFrequency := 15;
@export var randomTargetRadio := 0.5;

var totalTime := 0.0
var rng = RandomNumberGenerator.new();


func stop():
	self.paused = true;
	
func play():
	self.paused = false;
	updateTarget();
	
func setPlantPosition(position):
	plantPosition = position;
	
func target_met() -> bool:
	var forward = Vector2.RIGHT.rotated(rotation);
	var angleVector = target - owner.position;
	var rads := forward.angle_to(angleVector);
	var angle := rad_to_deg(rads);
	return angle > 90 || angle < -90;

func updateTarget():
	target = plantPosition + Vector2(rng.randf_range(0.0, randomTargetRadio), rng.randf_range(0.0, randomTargetRadio));
	self.rotation = (target - owner.position).angle();


func _process(delta):
	if (paused):
		return;
	if (target_met()):
		updateTarget();
	totalTime += delta;
	var forward_speed := Vector2.RIGHT.rotated(self.rotation) * forwardSpeed;
	var perpendicular_speed := Vector2.UP.rotated(self.rotation) * amplitude * sin(totalTime * oscilationFrequency);
	owner.position += (forward_speed + perpendicular_speed) * delta;
	return;
