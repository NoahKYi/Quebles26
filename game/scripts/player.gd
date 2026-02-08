extends CharacterBody2D

const SPEED = 70.0
const ACCEL = 100.0
const FRICTION = 50.0

var nearby_clues = []
var is_possessing = false
var original_player_position = Vector2.ZERO
var original_player_scale = Vector2.ZERO

@onready var possess_ui = get_node("../../UI/Possess")

func _ready():
	var detection_area = $DetectionArea
	detection_area.body_entered.connect(_on_clue_entered)
	detection_area.body_exited.connect(_on_clue_exited)
	original_player_scale = scale  # Store original scale
	
	# Hide the possess UI at start
	if possess_ui:
		possess_ui.visible = false

func _physics_process(delta):
	if is_possessing:
		velocity = Vector2.ZERO
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * SPEED, ACCEL * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()

func _process(delta):
	# Update UI visibility based on nearby clues
	if possess_ui:
		print("yes")
		possess_ui.visible = nearby_clues.size() > 0 and not is_possessing
	
	if Input.is_action_just_pressed("interact") and not is_possessing and nearby_clues.size() > 0:
		possess_nearest_clue()

func _on_clue_entered(body):
	if body.is_in_group("clues"):
		nearby_clues.append(body)

func _on_clue_exited(body):
	if body.is_in_group("clues"):
		nearby_clues.erase(body)

func possess_nearest_clue():
	var static_body = nearby_clues[0]
	var clue = static_body.get_meta("clue_node")
	
	is_possessing = true
	original_player_position = global_position
	
	# Start fading in the glow as player enters
	clue.fade_in_glow()
	
	# 1. Player moves to clue and shrinks (starts slow, accelerates HARD into it)
	var enter_tween = create_tween()
	enter_tween.set_parallel(true)
	enter_tween.tween_property(self, "global_position", clue.global_position, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	enter_tween.tween_property(self, "scale", Vector2.ZERO, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await enter_tween.finished
	
	# Make player invisible during possession
	visible = false
	
	# 2. Item rises and drops
	await clue.rise_and_drop()
	
	# Make player visible again before growing
	visible = true
	
	# Start fading out the glow as player exits
	clue.fade_out_glow()
	
	# 3. Player grows back and returns to original position (starts slow, accelerates HARD out)
	var exit_tween = create_tween()
	exit_tween.set_parallel(true)
	exit_tween.tween_property(self, "global_position", original_player_position, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	exit_tween.tween_property(self, "scale", original_player_scale, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await exit_tween.finished
	
	is_possessing = false
