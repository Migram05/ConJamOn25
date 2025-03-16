class_name SongAsset
extends Node

@export var song_file : Resource
@export var icon_image_file : Resource
@export var narrator_image_file : Resource
@export_file var enemies_file
@export_file var notes_file
@export_file var speech_file
@export_file var score_file

func _is_valid() -> bool:
	return song_file != null and enemies_file != null and notes_file != null and icon_image_file != null and narrator_image_file != null and speech_file != null and score_file != null
