extends Node2D

var paused := true;

var plantPosition : Vector2;
var target : Vector2;

@export var forwardSpeed := 1.0;
@export var amplitude := 100.0;
@export var oscilationFrequency := 15;
@export var randomTargetRadio := 0.5;
@export var amplitudeRandomRange := Vector2(0.2, 2.5);
var totalTime := 0.0;
var rng = RandomNumberGenerator.new();

var amplitudeRandomization := 1.0;

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

func updateRandomAmplitude():
	var s := sin(totalTime * oscilationFrequency)
	if (abs(s) < 0.1 || abs(s) > 0.9):
		amplitudeRandomization = rng.randf_range(amplitudeRandomRange.x, amplitudeRandomRange.y);

var total_speed : Vector2

func _process(delta):
	if (paused):
		return;
	if (target_met()):
		updateTarget();
	updateRandomAmplitude();
	totalTime += delta;
	var forward_speed := Vector2.RIGHT.rotated(self.rotation) * forwardSpeed;
	var perpendicular_speed = Vector2.UP.rotated(self.rotation) * amplitude * sin(totalTime * oscilationFrequency) * amplitudeRandomization;
	total_speed = (forward_speed + perpendicular_speed);
	owner.position += total_speed * delta;
	return;
