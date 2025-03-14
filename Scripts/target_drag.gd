extends Target

var dragging = false
var initialPos : Vector2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super()
	collision_shape_2d = $AnimationNode/Area2D/CollisionShape2D
	initialPos = position

func pressed(distanceNormalized, cursor) -> bool:
	if super(distanceNormalized, cursor):
		#Drag started
		dragging = true
		animation_player.play("Test")
	return false

func _process(delta: float) -> void:
	if dragging:
		if not cursorOn:
			dragging = false
			reset()
			initialPos = position
		else:
			var d = gameCursor.check_distance($".")
			if d < distance:
				score = score * d / distance
				distance = d
			if not animation_player.is_playing():
				queue_free()
				
				
func _click():
	pass
	
func _input(event):
	if dragging and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			dragging = false
			reset()
			initialPos = position
