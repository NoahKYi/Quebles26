extends Node2D

@onready var sprite2d = get_node("StaticBody2D/Sprite2D")
@onready var static_body = get_node("StaticBody2D")
@onready var impact_sound: AudioStreamPlayer2D = $Impact

func _ready():
	randomize()
	var texture_path = self.get_meta("sprite_image")
	sprite2d.texture = load(texture_path)
	
	# Add the StaticBody2D to clues group so player can detect it
	static_body.add_to_group("clues")
	# Store reference to parent so we can call rise_and_drop
	static_body.set_meta("clue_node", self)

func rise_and_drop():
	var original_y = sprite2d.position.y
	var original_x = sprite2d.position.x
	
	# Rise up with sway - create a custom sway animation
	var rise_time = 1.5  # Slower rise
	var sway_amount = 3  # How far it sways side to side
	
	var rise_tween = create_tween()
	rise_tween.set_parallel(true)
	rise_tween.tween_property(sprite2d, "position:y", original_y - 25, rise_time).set_ease(Tween.EASE_OUT)
	
	# Sway side to side using sine wave
	rise_tween.tween_method(func(t):
		sprite2d.position.x = original_x + sin(t * PI * 3) * sway_amount
	, 0.0, 1.0, rise_time)
	
	await rise_tween.finished
	
	# Drop down with gravity
	var drop_tween = create_tween()
	drop_tween.set_parallel(true)
	drop_tween.tween_property(sprite2d, "position:y", original_y, 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	drop_tween.tween_property(sprite2d, "position:x", original_x, 0.4)
	
	await drop_tween.finished
	
	impact_sound.play()
	
	# Create impact ring effect
	create_impact_ring()

func fade_in_glow():
	# Fade in the blue glow
	var glow_tween = create_tween()
	glow_tween.tween_property(sprite2d, "modulate", Color(0.6, 0.8, 1.5), 0.5)

func fade_out_glow():
	# Fade out the glow back to normal
	var glow_tween = create_tween()
	glow_tween.tween_property(sprite2d, "modulate", Color.WHITE, 0.5)

func create_impact_ring():
	# Create a Line2D node for the ring
	var ring = Line2D.new()
	add_child(ring)
	
	# Position at the base of the object
	ring.position = sprite2d.position
	
	# Ring appearance
	ring.width = 6.0
	ring.default_color = Color(0.924, 0.881, 0.815, 1.0)
	ring.antialiased = true
	
	# Create circle points
	var num_points = 32
	var start_radius = 5.0
	var end_radius = 150.0  # How far the ring expands
	
	for i in range(num_points + 1):
		var angle = (float(i) / num_points) * TAU
		var point = Vector2(cos(angle), sin(angle)) * start_radius
		ring.add_point(point)
	
	# Check for NPCs in range and make them react
	check_npcs_in_range(end_radius)
	
	# Animate the ring expanding and fading
	var ring_tween = create_tween()
	ring_tween.set_parallel(true)
	
	# Expand the ring
	ring_tween.tween_method(func(radius):
		for i in range(ring.get_point_count()):
			var angle = (float(i) / num_points) * TAU
			ring.set_point_position(i, Vector2(cos(angle), sin(angle)) * radius)
	, start_radius, end_radius, 0.6).set_ease(Tween.EASE_OUT)
	
	# Fade out
	ring_tween.tween_property(ring, "default_color:a", 0.0, 0.6).set_ease(Tween.EASE_OUT)
	
	# Thin the line as it expands
	ring_tween.tween_property(ring, "width", 1.0, 0.6).set_ease(Tween.EASE_OUT)
	
	await ring_tween.finished
	
	# Clean up
	ring.queue_free()

func check_npcs_in_range(radius: float):
	# Get all NPCs in the scene
	var npcs = get_tree().get_nodes_in_group("family_members")
	
	for npc in npcs:
		# Check if NPC is within the sound radius
		var distance = global_position.distance_to(npc.global_position)
		print(npc.display_name, distance)
		if distance * 2 <= radius:
			npc.say("heard_sound")
