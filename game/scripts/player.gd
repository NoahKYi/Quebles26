extends CharacterBody2D

const SPEED = 70.0
const ACCEL = 100.0
const FRICTION = 50.0

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")

	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * SPEED, ACCEL * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()
