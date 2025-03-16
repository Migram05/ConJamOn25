extends Node

var missed_notes : int
var meh_notes : int
var good_notes : int
var perfect_notes : int

var moscas_killed : int
var ciempieses_killed : int

var height : float

func clicked_note(precision : NoteSpawner.NotePrecision):
	print("received")
	match(precision):
		NoteSpawner.NotePrecision.MISSED:
			missed_notes += 1
		NoteSpawner.NotePrecision.BAD:
			meh_notes += 1
		NoteSpawner.NotePrecision.GOOD:
			good_notes += 1
		NoteSpawner.NotePrecision.PERFECT:
			perfect_notes += 1
		_:
			pass
	

func mosca_killed():
	moscas_killed += 1

func ciempies_killed():
	ciempieses_killed += 1
