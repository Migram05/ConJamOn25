extends Node2D
class_name LevelPlant

var displayName : String:
	set(new_text):
		displayName = new_text
		$Button.text = new_text.to_upper()
		
var lastScore : String:
	set(new_text):
		lastScore = new_text
		$Button/LastScoreLabel.text = "Last Score: " + new_text

var song_file_path : String
var events_file_path : String
var speech_file_path : String
var narrator_image_path : String

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
			GameManager._narrator_image = Image.load_from_file(narrator_image_path)
		else:
			GameManager._song = load(song_file_path)
			GameManager._narrator_image = load(narrator_image_path)
		GameManager._events = FileAccess.open(events_file_path, FileAccess.READ).get_as_text()
		if(!speech_file_path.is_empty()):
			GameManager._speech = FileAccess.open(speech_file_path, FileAccess.READ).get_as_text()
		else:
			GameManager._speech = defaultSpeech
		SceneManager.loadScene(SceneManager._SCENES_.SELECTION_MENU);

func GoToHistorial() -> void:
	SceneManager.loadScene(SceneManager._SCENES_.HISTORIAL_MENU);

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

func _on_button_mouse_exited() -> void:
	preview_sound_volume = 0
	preview_max_sound_volume = -1
	$AudioStreamPlayer2D.stop()
