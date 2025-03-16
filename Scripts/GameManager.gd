extends Node

var _score : int = 0
enum _TREE_TYPE_{
	SEMILLA,
	BROTE,
	PLANTA,
	ARBUSTO,
	ARBOL
}

var tree_type_by_height : Array[float] = [
	0.0,
	0.01,
	0.03,
	0.04,
	0.05
]

var _treeType : _TREE_TYPE_ = _TREE_TYPE_.SEMILLA
var _audioPlayer : AudioStreamPlayer2D
var _volume : float = 100:
	set(new_value):
		_volume = new_value
		if new_value < 1:
			_audioPlayer.volume_db = -1000
		else:
			_audioPlayer.volume_db = -40 + new_value * 40 /100
var _fullScreen : bool

var _currentLevel:int=0
var _song : Resource:
	set(new_file):
		_audioPlayer.stream = new_file
var _notes : String
var _enemies : String
var _speech : String
var _narrator_image : Resource
var _current_level_name : String
var _score_content : String

func _play_song():
	if _audioPlayer.stream  != null:
		_audioPlayer.play()
		
func _stop_song():
	if _audioPlayer.stream  != null:
		_audioPlayer.stop()
		
func _ready() -> void:
	_audioPlayer = AudioStreamPlayer2D.new()
	add_child(_audioPlayer)
	
func _get_volume_DB() -> float:
	if _audioPlayer != null:
		return _audioPlayer.volume_db
	return 0
