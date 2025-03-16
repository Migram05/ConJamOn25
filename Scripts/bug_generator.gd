class_name BugGenerator
extends Node2D

@onready var min_spawn_distance: Node2D = $MinSpawnDistance
@onready var max_spawn_distance: Node2D = $MaxSpawnDistance
@onready var minijuego_piano_tiles: NoteSpawner = $"../MinijuegoPianoTiles"
@onready var min_special_spawn_distance: Node2D = $MinSpecialSpawnDistance
@onready var max_special_spawn_distance: Node2D = $MaxSpecialSpawnDistance

@export var plantNode : Node2D;

const COMMON_BEAT : float = 120
var currentBeat = 0
const TARGET = preload("res://Scenes/Objects/target.tscn")
var rng = RandomNumberGenerator.new()
const NUMBER_OF_BEATS_PER_ENEMY = 10
var spawn_timer : float = 0
var spawn_max_timer : float = 0
var current_enemies = 0
const RELATION_BETWEEN_NOTES_AND_ENEMIES = 3
const SPAWN_NORMAL_RNG = 80
const TARGET_DRAG = preload("res://Scenes/Objects/targetDrag.tscn")
var pause : bool = true

func _ready():
	var file = GameManager._enemies.split("\n")
	currentBeat = (float)(file[0])
	spawn_max_timer = NUMBER_OF_BEATS_PER_ENEMY * 60 / currentBeat
	
	
func _process(delta: float) -> void:
	if not pause:
		spawn_timer += delta
		if spawn_timer < spawn_max_timer:
			if current_enemies < minijuego_piano_tiles.current_notes / RELATION_BETWEEN_NOTES_AND_ENEMIES:
				if randi_range(0, 100) < SPAWN_NORMAL_RNG:
					spawnNormalEnemy()
				else:
					spawnSpecialEnemy()
			spawn_timer = spawn_timer - spawn_max_timer
	
	print("Enemies left: " + str(current_enemies))
		
	
func spawnNormalEnemy():
	var enemy = TARGET.instantiate()
	current_enemies += 1
	add_child(enemy)
	if rng.randi_range(0, 1) == 1:
		enemy.global_position.x = randf_range(min_spawn_distance.global_position.x, max_spawn_distance.global_position.x)
		enemy.global_position.y = randf_range(min_spawn_distance.global_position.y, max_spawn_distance.global_position.y)
	else:
		enemy.global_position.x = randf_range(-min_spawn_distance.global_position.x, -max_spawn_distance.global_position.x)
		enemy.global_position.y = randf_range(-min_spawn_distance.global_position.y, -max_spawn_distance.global_position.y)
	var sprite : AnimatedSprite2D = enemy.get_node("AnimationNode/AnimatedSprite2D")
	sprite.speed_scale = currentBeat / COMMON_BEAT
	
func spawnSpecialEnemy():
	var enemy = TARGET_DRAG.instantiate()
	current_enemies += 1
	add_child(enemy)
	if rng.randi_range(0, 1) == 1:
		enemy.global_position.x = randf_range(min_special_spawn_distance.global_position.x, max_special_spawn_distance.global_position.x)
		enemy.global_position.y = randf_range(min_special_spawn_distance.global_position.y, max_special_spawn_distance.global_position.y)
	else:
		enemy.global_position.x = randf_range(-min_special_spawn_distance.global_position.x, -max_special_spawn_distance.global_position.x)
		enemy.global_position.y = randf_range(-min_special_spawn_distance.global_position.y, -max_special_spawn_distance.global_position.y)
	var sprite : AnimatedSprite2D = enemy.get_node("AnimationNode/AnimatedSprite2D")
	enemy.enemyState = Target.State.OPEN	
	
	
