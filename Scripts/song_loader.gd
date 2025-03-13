extends Node
@export var plantLevelClass : PackedScene
@export var levelsDirectory : String
const VALID_AUDIO_EXTENSIONS : Array[String] = ["wav", "mp3", "ogg"]
const EVENTS_FILE_NAME : String = "events.txt"

var spawnedPlants : int = 0

func _ready() -> void:
	if plantLevelClass != null:
		scan_directories(levelsDirectory)
		print("NUM found: " + str(spawnedPlants))
	else:
		printerr("SongManager: No plant level selector class chosen")

# Navega por todos los directorios y archivos de la ruta dada.
# Este es el método encargado de guardar las canciones válidas en el contenedor correspondiente
func scan_directories(path : String):
	var dir = DirAccess.open(path)
	if dir:
		var dir_array = DirAccess.get_directories_at(path)
		# Lista de directorios en la ruta dada (excluyendo archivos regulares) y ordenados alfabeticamente
		for song_dir in dir_array:
			print("Found dir " + str(song_dir))
			# Lista de todos los archivos (excluidos los directorios) odenados alfabeticamente
			var files_path : String = path + "/" + song_dir
			var song_dir_files = DirAccess.get_files_at(files_path)
			_register_song(song_dir_files, files_path)
	else:
		printerr("An error occurred when trying to access the path: " + levelsDirectory)

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

# Registra la canción dado su directorio: busca los archivos necesarios para poder lanzar un nivel
# Devuelve true en caso de encontrar todos los archivos, false en caso contrario
func _register_song(files_array : PackedStringArray, files_path : String) -> bool:
	var song_file_found : bool = false
	var events_file_found : bool = false
	var song_file_path : String
	var events_file_path : String
	var song_file_name : String
	var events_file_name : String
	for file in files_array:
		if(!song_file_found and VALID_AUDIO_EXTENSIONS.has(_get_file_extension(file).to_lower())):
			song_file_found = true
			song_file_path = files_path + "/" + file
			song_file_name = _get_file_name(file)
		elif(!events_file_found and file.to_lower() == EVENTS_FILE_NAME.to_lower()):
			events_file_found = true
			events_file_path = files_path + "/" + file
			events_file_name = _get_file_name(file)
		if(song_file_found and events_file_found):
			_add_song(song_file_name, 999, song_file_path, events_file_path)
			return true
	return false

# Crea un objeto de tipo planta, que sirve como botón para acceder a un nivel.
# La planta guarda la ruta a los archivos necesarios para iniciar un nuevo nivel
func _add_song(song_name : String, last_score : int, song_path : String, events_path : String):
	var new_level_plant : LevelPlant = plantLevelClass.instantiate()
	add_child(new_level_plant)
	new_level_plant.position = Vector2(200 *spawnedPlants, 0)
	spawnedPlants += 1
	new_level_plant.displayName = song_name
	new_level_plant.lastScore = str(999)
	new_level_plant.song_file_path = song_path
	new_level_plant.events_file_path = events_path
