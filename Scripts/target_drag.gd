extends Target

var dragging = false
var initialPos : Vector2
var errorDistance = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var sprite_frames : Array[SpriteFrames]
@export var animated_sprite : AnimatedSprite2D

var animation_node_name : String

func _ready() -> void:
	super()
	collision_shape_2d = $AnimationNode/Area2D/CollisionShape2D
	initialPos = position
	var index = randi() % sprite_frames.size()
	animated_sprite.sprite_frames = sprite_frames[index]
	animation_node_name = ("centipede_" + str(index)) 
	animation_player.current_animation = animation_node_name
	animation_player.stop()

func pressed(distanceNormalized, cursor) -> bool:
	if super(distanceNormalized, cursor):
		#Drag started
		dragging = true
		animation_player.play(animation_node_name)
		errorDistance = distance
	return false

func _process(delta: float) -> void:
	if dragging:
		if not cursorOn:
			dragging = false
			animation_player.stop()
			reset()
			initialPos = position
		else:
			if not animation_player.is_playing():
				score = score * errorDistance
				var inst : Node2D = moscaMuelta.instantiate();
				get_parent().add_child(inst);
				inst.global_position = self.global_position;
				queue_free()
				ScoreRegister.ciempies_killed()
				return
			var d = gameCursor.check_distance($".")
			if d < errorDistance:
				print(errorDistance)
				errorDistance = d
		
				
				
func _click(perfect = false):
	pass
	
func _input(event):
	if dragging and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			dragging = false
			animation_player.stop()
			reset()
			initialPos = position
			
