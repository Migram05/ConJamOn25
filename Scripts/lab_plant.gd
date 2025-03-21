extends Node2D
class_name LevelPlant

var displayName : String:
	set(new_text):
		displayName = new_text
		$Panel/SongName.text = new_text.to_upper()
		
var lastScore : String:
	set(new_text):
		lastScore = new_text
		$Panel/Score.text = new_text

var song_file_path : String
var enemies_file_path : String
var notes_file_path : String
var speech_file_path : String
var narrator_image_path : String
var score_file_path : String
#var score_content : String
		
var icon_image_path : String:
	set(path):
		icon_image_path = path
		$Image.texture = load(icon_image_path)
		$Image.scale = Vector2(250,250) / $Image.texture.get_size()
		$Maceta.scale = Vector2(125,125) / $Maceta.texture.get_size()

func setScale(scale : float):
	$Image.scale = (Vector2(250,250) / $Image.texture.get_size())*scale
	$Maceta.scale = Vector2(125,125) / $Maceta.texture.get_size()*scale
	
func showPanel(show : bool):
	$Panel/Historial.visible=show
	$Panel/Banner.visible=show
	$Panel/Song/PlaySong.visible=show
	if show:
		$Panel/AnimationPlayer.play("Grow")

func setColorGradient(red : float, green : float, blue : float, alpha : float):
	if red > 0:
		$Image.self_modulate.r = red
		$Maceta.self_modulate.r = red
	if green > 0:
		$Image.self_modulate.g = green
		$Maceta.self_modulate.g = red
	if blue > 0:
		$Image.self_modulate.b = blue
		$Maceta.self_modulate.b = red
	if alpha > 0:
		$Image.self_modulate.a = alpha
		$Maceta.self_modulate.a = red

# Cómo de rápido aumenta el volumen de la preview cuando se está reproduciendo
@export var preview_sound_volume_increase : float = 25
# Volumen al que comienza la preview de la canción
@export var preview_sound_volume_start : float = -25
@export var defaultSpeech : String = "Este es el texto por defecto, si ves esto es que no se ha cambiado, si quieres cambiar el texto que aparece cuando no se detecta un achivo de tipo speech.txt ve al Prefab (no lo voy a llamar escena) del song loader y cambia la propiedad de default speech desde editor"

var preview_max_sound_volume : float = -1
var preview_sound_volume : float = 0

# Permite indicar si el nivel que queremos cargar es un mod o no
# Dependiendo de eso, la carga de archivos se realiza de manera diferente
var moded_level : bool = false

func _process(delta: float) -> void:
	if preview_max_sound_volume != -1 and preview_sound_volume < preview_max_sound_volume:
		preview_sound_volume += preview_sound_volume_increase * delta
		if preview_sound_volume >= preview_max_sound_volume:
			preview_sound_volume = preview_max_sound_volume
		$AudioStreamPlayer2D.volume_db = preview_sound_volume

func _on_button_pressed() -> void:
	if(GameManager != null):
		$AudioStreamPlayer2D.stop()
		if moded_level:
			GameManager._song = AudioStreamOggVorbis.load_from_file(song_file_path)
			GameManager._isCurrentNarratorMod = true
		else:
			GameManager._isCurrentNarratorMod = false
			GameManager._song = load(song_file_path)
		GameManager._narrator_image = load(narrator_image_path)
		GameManager._enemies = FileAccess.open(enemies_file_path, FileAccess.READ).get_as_text()
		GameManager._notes = FileAccess.open(notes_file_path, FileAccess.READ).get_as_text()
		if(!speech_file_path.is_empty()):
			GameManager._speech = FileAccess.open(speech_file_path, FileAccess.READ).get_as_text()
		else:
			GameManager._speech = defaultSpeech
		GameManager._score_file_path = score_file_path
		SceneManager.loadScene(SceneManager._SCENES_.SELECTION_MENU);

func GoToHistorial() -> void:
	GameManager._score_file_path = score_file_path
	GameManager._current_level_name = $Panel/SongName.text
	SceneManager.loadScene(SceneManager._SCENES_.HISTORIAL);

func GoToSelection() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.SELECTION_MENU);
	
func _on_button_mouse_entered() -> void:
	if($AudioStreamPlayer2D.stream == null):
		if moded_level:
			$AudioStreamPlayer2D.stream = AudioStreamOggVorbis.load_from_file(song_file_path)
		else:
			$AudioStreamPlayer2D.stream = load(song_file_path)
	if(GameManager != null):
		preview_max_sound_volume = GameManager._get_volume_DB()
	preview_sound_volume = preview_sound_volume_start
	$AudioStreamPlayer2D.volume_db = preview_sound_volume
	$AudioStreamPlayer2D.play()
	$Panel/Song/AnimationPlayer.play("Song")

func _on_button_mouse_exited() -> void:
	preview_sound_volume = 0
	preview_max_sound_volume = -1
	$AudioStreamPlayer2D.stop()
	$Panel/Song/AnimationPlayer.stop()
