extends Sprite2D


@export var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _getInput():
	var direction = Vector2.ZERO
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var velocity = input_direction * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _movement(delta: float) -> void:
	
	if Input.is_action_pressed("right"):
		direction.x += 1
	elif Input.is_action_pressed("left"):
		direction.x -= 1
	elif Input.is_action_pressed("up"):
		direction.x 
	
