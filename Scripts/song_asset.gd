class_name SongAsset
extends Node

@export var song_file : Resource
@export_file var events_file

func _is_valid() -> bool:
	return song_file != null and events_file != null
