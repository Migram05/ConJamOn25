extends Node
@export var plantLevelClass : PackedScene
@export var defaultLevels : Array[SongAsset]
@export var placeholderImage : Resource
#region ModedLevelsRegion
const VALID_MOD_AUDIO_EXTENSION : String = "ogg"
const ENEMIES_FILE_NAME : String = "enemies.txt"
const NOTES_FILE_NAME : String = "notes.txt"
const SPEECH_FILE_NAME : String = "speech.txt"
const MODS_FOLDER_NAME : String = "/GodotMods"
#endregion

class Plant:
	var song_name : String
	var last_score : int
	var song_path : String
	var enemies_file_path : String
	var notes_file_path : String
	var speech_path : String 
	var icon_image_path : String
	var narrator_image_path : String
	var moded : bool = false
var _listPlants : Array[Plant]
var _inGamePlants : Array[LevelPlant]

func _ready() -> void:
	if plantLevelClass != null:
		_load_default_levels()
		print("Number of default levels found: " + str(GameManager._currentLevel))
		_load_moded_levels()
		print("Number of moded levels found: " + str(GameManager._currentLevel))
		showPlants()
	else:
		printerr("SongManager: No plant level selector class chosen")

# Carga los niveles por defecto del juego, estos niveles se tienen que especificar como archivos de tipo escena "Song Asset"
# Estos archivos tienen una referencia a cada archivo necesario para lanzar un nivel
func _load_default_levels():
	for asset in defaultLevels:
		if asset._is_valid():
			_add_song(_get_file_name(asset.song_file.resource_path.get_file()), 999, asset.song_file.resource_path, asset.enemies_file, asset.notes_file, asset.icon_image_file.resource_path, asset.narrator_image_file.resource_path, asset.speech_file)

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
	var enemies_file_found : bool = false
	var notes_file_found : bool = false
	var speech_file_found : bool = false
	var song_file_path : String
	var enemies_file_path : String
	var notes_file_path : String
	var song_file_name : String
	var speech_file_path : String
	var icon_image_path : String
	var narrator_image_path : String
	for file in files_array:
		if(!song_file_found and VALID_MOD_AUDIO_EXTENSION == _get_file_extension(file).to_lower()):
			song_file_found = true
			song_file_path = files_path + "/" + file
			song_file_name = _get_file_name(file)
		elif(!enemies_file_found and file.to_lower() == ENEMIES_FILE_NAME.to_lower()):
			enemies_file_found = true
			enemies_file_path = files_path + "/" + file
		elif(!notes_file_found and file.to_lower() == NOTES_FILE_NAME.to_lower()):
			notes_file_found = true
			notes_file_path = files_path + "/" + file
		elif (!speech_file_found and file.to_lower() == SPEECH_FILE_NAME.to_lower()):
			speech_file_found = true
			speech_file_path = files_path + "/"+ file
	if(song_file_found and enemies_file_found and notes_file_found):
		if(placeholderImage != null):
			icon_image_path = placeholderImage.resource_path
			narrator_image_path = placeholderImage.resource_path
		if(!speech_file_found):
			speech_file_path = ""
		_add_song(song_file_name, 999, song_file_path, enemies_file_path, notes_file_path, icon_image_path, narrator_image_path, speech_file_path,true)
		return true	
	return false

# Crea un objeto de tipo planta, que sirve como botón para acceder a un nivel.
# La planta guarda la ruta a los archivos necesarios para iniciar un nuevo nivel
func _add_song(song_name : String, last_score : int, song_path : String, enemies_file_path : String, notes_path : String, icon_image_path : String, narrator_image_path : String, speech_path : String , moded : bool = false):
	print("New song info: " + song_name + " Path: " + song_path + " Enemies: " + enemies_file_path + " Icon: " + icon_image_path + " Narrator: " + narrator_image_path)
	var newPlant : Plant = Plant.new()
	newPlant.song_name = song_name
	newPlant.last_score = int(last_score)
	newPlant.song_path = song_path
	newPlant.enemies_file_path = enemies_file_path
	newPlant.notes_file_path = notes_path
	newPlant.icon_image_path = icon_image_path
	newPlant.narrator_image_path = narrator_image_path
	newPlant.speech_path = speech_path
	newPlant.moded = moded
	_listPlants.append(newPlant)

func showPlants():
	var i : int = 0
	if _inGamePlants.size() !=0:
		for plant in _inGamePlants:
			plant.queue_free()
		_inGamePlants.clear()
	while i<3:
		var new_level_plant : LevelPlant = plantLevelClass.instantiate()
		add_child(new_level_plant)
		_inGamePlants.append(new_level_plant)
		var num : int = DisplayServer.screen_get_size().x/4.25
		new_level_plant.position = Vector2(-num*0.8+ num*i, 150)
		
		var aux : int = (GameManager._currentLevel + (-1+i))
		if GameManager._currentLevel==0 && i==0:
			aux = _listPlants.size()-1
		elif GameManager._currentLevel == _listPlants.size()-1 && i==2:
			aux = 0
		new_level_plant.displayName = _listPlants[aux].song_name
		new_level_plant.lastScore = str(_listPlants[aux].last_score)
		new_level_plant.song_file_path = _listPlants[aux].song_path
		new_level_plant.enemies_file_path = _listPlants[aux].enemies_file_path
		new_level_plant.notes_file_path = _listPlants[aux].notes_file_path
		new_level_plant.icon_image_path =_listPlants[aux].icon_image_path
		new_level_plant.narrator_image_path = _listPlants[aux].narrator_image_path
		new_level_plant.speech_file_path = _listPlants[aux].speech_path
		new_level_plant.moded_level = _listPlants[aux].moded
		if i==1:
			new_level_plant.setScale(1.25)
			new_level_plant.showPanel(true)
		else:
			new_level_plant.setColorGradient(0.35,0.35,0.35,-1)
			new_level_plant.showPanel(false)
		i+=1

func _input(event: InputEvent) -> void: 
	if event.is_action_pressed("arrow_left"):
		MoveLeft()
	elif event.is_action_pressed("arrow_right"):
		MoveRight()

func MoveLeft():
	GameManager._currentLevel = (_listPlants.size() + GameManager._currentLevel-1)%_listPlants.size()
	showPlants()
	
func MoveRight():
	GameManager._currentLevel = (GameManager._currentLevel+1)%_listPlants.size()
	showPlants()

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
