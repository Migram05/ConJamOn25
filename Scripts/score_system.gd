extends Node2D
class_name ScoreSystem

@export var text : RichTextLabel
@export var height_by_precision : Array[float]

var score : float

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func score_point(hit_score : NoteController.NotePrecision):
	#var instance = spontaneous_text.instantiate()
	#self.add_child(instance)
	#
	#var label : RichTextLabel = instance
	
	score += height_by_precision[hit_score]
	text.text = str(round_to_dec(score, 2)) + " M"
	
	ScoreRegister.height = score
