extends Node
@export var plantLevelClass : PackedScene
var spawnedPlants : int = 0
@export var defaultLevels : Array[SongAsset]
@export var defaultNarratorImage : Resource
#region ModedLevelsRegion
const VALID_MOD_AUDIO_EXTENSION : String = "ogg"
const NARRATOR_IMAGE_NAME : String = "narrator.png"
const EVENTS_FILE_NAME : String = "events.txt"
const NOTES_FILE_NAME : String = "notes.txt"
const SPEECH_FILE_NAME : String = "speech.txt"
const MODS_FOLDER_NAME : String = "/GodotMods"
#endregion

func _ready() -> void:
	if plantLevelClass != null:
		_load_default_levels()
		print("Number of default levels found: " + str(spawnedPlants))
		_load_moded_levels()
		print("Number of moded levels found: " + str(spawnedPlants))
	else:
		printerr("SongManager: No plant level selector class chosen")

# Carga los niveles por defecto del juego, estos niveles se tienen que especificar como archivos de tipo escena "Song Asset"
# Estos archivos tienen una referencia a cada archivo necesario para lanzar un nivel
func _load_default_levels():
	for asset in defaultLevels:
		if asset._is_valid():
			_add_song(_get_file_name(asset.song_file.resource_path.get_file()), 999, asset.song_file.resource_path, asset.events_file, asset.notes_file, asset.narrator_image_file.resource_path, asset.speech_file)

# Carga los archivos que se encuentren en la carpeta designada para los mods
# La carpeta de mods tiene que estar creada en el mismo directorio que el ejecutable
func _load_moded_levels():
	var modLoadPath: String = OS.get_executable_path().get_base_dir() + MODS_FOLDER_NAME
	if !modLoadPath.is_empty() and modLoadPath.is_absolute_path():
		_scan_directories(modLoadPath)

# Navega por todos los directorios y archivos de la ruta dada.
# Este es el método encargado de guardar las canciones válidas en el contenedor correspondiente
func _scan_directories(path : String):
	var dir = DirAccess.open(path)
	if dir:
		var dir_array = DirAccess.get_directories_at(path)
		# Lista de directorios en la ruta dada (excluyendo archivos regulares) y ordenados alfabeticamente
		for song_dir in dir_array:
			print("Found mod dirrectory " + str(song_dir))
			# Lista de todos los archivos (excluidos los directorios) odenados alfabeticamente
			var files_path : String = path + "/" + song_dir
			var song_dir_files = DirAccess.get_files_at(files_path)
			_register_moded_song(song_dir_files, files_path)
	else:
		printerr("An error occurred when trying to access the moded levels path: " + path)

# Registra la canción dado su directorio: busca los archivos necesarios para poder lanzar un nivel
# Devuelve true en caso de encontrar todos los archivos, false en caso contrario
# Por si a alguien le apetece refactorizar este código es un poco feo
func _register_moded_song(files_array : PackedStringArray, files_path : String) -> bool:
	var song_file_found : bool = false
	var events_file_found : bool = false
	var notes_file_found : bool = false
	var speech_file_found : bool = false
	var narrator_image_file_found : bool = false
	var song_file_path : String
	var events_file_path : String
	var notes_file_path : String
	var song_file_name : String
	var narrator_image_path : String
	var speech_file_path : String
	for file in files_array:
		if(!song_file_found and VALID_MOD_AUDIO_EXTENSION == _get_file_extension(file).to_lower()):
			song_file_found = true
			song_file_path = files_path + "/" + file
			song_file_name = _get_file_name(file)
		elif(!events_file_found and file.to_lower() == EVENTS_FILE_NAME.to_lower()):
			events_file_found = true
			events_file_path = files_path + "/" + file
		elif(!notes_file_found and file.to_lower() == NOTES_FILE_NAME.to_lower()):
			notes_file_found = true
			notes_file_path = files_path + "/" + file
		elif(!narrator_image_file_found and file.to_lower() == NARRATOR_IMAGE_NAME.to_lower()):
			narrator_image_file_found = true
			narrator_image_path = files_path + "/" + file
		elif (!speech_file_found and file.to_lower() == SPEECH_FILE_NAME.to_lower()):
			speech_file_found = true
			speech_file_path = files_path + "/"+ file
	if(song_file_found and events_file_found and notes_file_found):
		if(!narrator_image_file_found):
			if(defaultNarratorImage != null):
				narrator_image_path = defaultNarratorImage.resource_path
		if(!speech_file_found):
			speech_file_path = ""
		_add_song(song_file_name, 999, song_file_path, events_file_path, notes_file_path, narrator_image_path, speech_file_path,true)
		return true	
	return false

# Crea un objeto de tipo planta, que sirve como botón para acceder a un nivel.
# La planta guarda la ruta a los archivos necesarios para iniciar un nuevo nivel
func _add_song(song_name : String, last_score : int, song_path : String, events_path : String, notes_path : String, narrator_image_path : String, speech_path : String , moded : bool = false):
	print("New song info: " + song_name + " Path: " + song_path + " Events: " + events_path)
	var new_level_plant : LevelPlant = plantLevelClass.instantiate()
	add_child(new_level_plant)
	new_level_plant.position = Vector2(200 *spawnedPlants, 0)
	spawnedPlants += 1
	new_level_plant.displayName = song_name
	new_level_plant.lastScore = str(999)
	new_level_plant.song_file_path = song_path
	new_level_plant.events_file_path = events_path
	new_level_plant.notes_file_path = notes_path
	new_level_plant.narrator_image_path = narrator_image_path
	new_level_plant.speech_file_path = speech_path
	new_level_plant.moded_level = moded

# Devuelve la extensión del archivo pasado como argumento, este método se encarga de hacer el split del string y coger la primera extensión encontrada
# En caso de no poder hacer la separación del string o si el nombre de archivo no es válido, devuelve "NULL"
func _get_file_extension(file_name : String) -> String:
	var returned_file_extension : String = "NULL"
	if !file_name.is_empty():
		# Divide el String en 2, a partir del primer caracter de punto encontrado (".")
		# Además, ignora los espacios en el String
		var name_split = file_name.split(".", false, 1)
		if(name_split.size() >= 2):
			returned_file_extension = name_split[1]
	return returned_file_extension
	
# Devuelve el nombre del archivo pasado como argumento, este método se encarga de hacer el split del string y coger el nombre antes de la extensión
# En caso de no poder hacer la separación del string o si el nombre de archivo no es válido, devuelve "NULL"
func _get_file_name(file_name : String) -> String:
	var returned_file_name : String = "NULL"
	if !file_name.is_empty():
		# Divide el String en 2, a partir del primer caracter de punto encontrado (".")
		# Además, ignora los espacios en el String
		var name_split = file_name.split(".", false, 1)
		if(name_split.size() >= 2):
			returned_file_name = name_split[0]
	return returned_file_name
