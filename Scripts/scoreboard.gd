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

func _ready() -> void:
	missed_text.text = str(ScoreRegister.missed_notes)
	meh_text.text = str(ScoreRegister.meh_notes)
	good_text.text = str(ScoreRegister.good_notes)
	perfect_text.text = str(ScoreRegister.perfect_notes)
	moscas_text.text = str(ScoreRegister.moscas_killed)
	ciempieses_text.text = str(ScoreRegister.ciempieses_killed)
	
	var tree_type : String = "SEMILLA"
	
	var index = 0
	for i in GameManager._TREE_TYPE_:
		var height = GameManager.tree_type_by_height[index]
		if height <= ScoreRegister.height:
			tree_type = i
			index += 1
		else: 
			break
		
	var height_rounded : float = round_to_dec(ScoreRegister.height, 2)
	categoria.text = tree_type + "\n" +  str(height_rounded) + " M"
	plant.texture = plant.textures[index]

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func BackToLabMenu():
	SceneManager.loadScene(SceneManager._SCENES_.LAB_MENU)
	if team_name_input.text == "":
		ScoreRegister.team_name = "SIN NOMBRE ;("
		
	print(ScoreRegister.team_name)

func WriteTeamName(new_text : String):
	ScoreRegister.team_name = new_text
