extends Node

var _score : int = 0 
enum _TREE_TYPE_{
	SEMILLA,
	BROTE,
	PLANTA,
	ARBUSTO,
	ARBOL
}
var _treeType : _TREE_TYPE_ = _TREE_TYPE_.SEMILLA
var _volume : float = 100
var _fullScreen : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
