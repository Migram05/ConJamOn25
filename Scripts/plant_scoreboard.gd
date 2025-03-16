extends Sprite2D
class_name PlantScoreboard

@export var textures : Array[Texture2D]

func set_plant_texture(index : int) -> void:
	self.texture = textures[index]
