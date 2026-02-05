extends Node2D
@onready var sprite2d = get_node("StaticBody2D/Sprite2D")

func _ready():
	randomize() #initialize godot's random number generator (probably just need this once per game run so should be moved to another file later)
	var texture_path = self.get_meta("sprite_image");
	sprite2d.texture = load(texture_path)
	
func _process(delta: float):
	
	pass
	
