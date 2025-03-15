extends Node2D

var paused := true;
	
func stop():
	self.paused = false;
	
func play():
	self.paused = true;
	
func _process(delta):
	if (paused):
		return
	# TO DO: wander behaviour
	return
