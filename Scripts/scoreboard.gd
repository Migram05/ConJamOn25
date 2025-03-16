extends Node2D
class_name ScoreBoard

@export var missed_text : Label
@export var meh_text : Label
@export var good_text : Label
@export var perfect_text : Label
@export var moscas_text : Label
@export var ciempieses_text : Label
@export var categoria : RichTextLabel
@export var plant : PlantScoreboard
@export var team_name_input : LineEdit

var tree_type : String = "SEMILLA"

func _ready() -> void:
	missed_text.text = str(ScoreRegister.missed_notes)
	meh_text.text = str(ScoreRegister.meh_notes)
	good_text.text = str(ScoreRegister.good_notes)
	perfect_text.text = str(ScoreRegister.perfect_notes)
	moscas_text.text = str(ScoreRegister.moscas_killed)
	ciempieses_text.text = str(ScoreRegister.ciempieses_killed)
	
	var index = 0
	var ola = 0
	for i in GameManager._TREE_TYPE_:
		var height = GameManager.tree_type_by_height[index]
		var points = height * ScoreRegister.total_notes
		if points <= ScoreRegister.height:
			tree_type = i
			ola = index
			index += 1
		else: 
			break
	
	index = clamp(ola, 0, plant.textures.size() - 1)
	
	var height_rounded : float = round_to_dec(ScoreRegister.height, 2)
	categoria.text = tree_type + "\n" +  str(height_rounded) + " M"
	plant.texture = plant.textures[index]

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func BackToLabMenu():
	if team_name_input.text == "":
		ScoreRegister.team_name = "SIN NOMBRE :("
	SaveScore()
	SceneManager.loadScene(SceneManager._SCENES_.LAB_MENU)

func SaveScore():
	var score_file = FileAccess.open(GameManager._score_file_path, FileAccess.READ)
	var content : String = score_file.get_as_text()
	content += ScoreRegister.team_name + " " + str(str(round_to_dec(ScoreRegister.height, 2))) + " " + str(ScoreRegister.moscas_killed) + " " + str(ScoreRegister.ciempieses_killed) + " " + str(ScoreRegister.perfect_notes) + " " + str(ScoreRegister.good_notes) + " " + str(ScoreRegister.meh_notes) + " " + str(ScoreRegister.missed_notes) + "\n"
	var file = FileAccess.open(GameManager._score_file_path, FileAccess.WRITE)
	file.store_string(content)

func WriteTeamName(new_text : String):
	ScoreRegister.team_name = new_text
