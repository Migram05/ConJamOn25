extends Node

var allScenes = [preload("res://Scenes/Menus/MainMenu.tscn"),
				preload("res://Scenes/Menus/Options.tscn"),
				preload("res://Scenes/Levels/LabMenu.tscn")]
enum _SCENES_{
	MAIN_MENU,
	OPTIONS,
	LAB_MENU,
	SELECTION_MENU,
	GAME_LEVEL,
	SCORE_SCENE
	}
var _currSceneID : _SCENES_ = _SCENES_.MAIN_MENU

class InGameScene:
	var _type : _SCENES_;
	var _name : String;
	var _sceneNode : Node;
var _currSceneInGame : InGameScene = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadScene(SceneManager._SCENES_.MAIN_MENU)
	
func loadScene(_nextSceneID : _SCENES_) -> int:
	if(_nextSceneID >= allScenes.size() || !allScenes[_nextSceneID].can_instantiate()):
		return -1;
	if(_currSceneInGame != null):
		_currSceneInGame._sceneNode.queue_free()
		_currSceneInGame=null;
	
	var newScene : Node = allScenes[_nextSceneID].instantiate();
	if(newScene==null):
		return -1;
	_currSceneInGame = InGameScene.new();
	_currSceneInGame._sceneNode = newScene;
	_currSceneInGame._type = _nextSceneID;
	_currSceneInGame._name = allScenes[_nextSceneID]._bundled["names"][0];
	
	_currSceneID = _nextSceneID;
	add_child(newScene);
	return 0;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
