extends Control

var time_left := 60.0 * 3 # seconds
var game_over := false

func _ready():
	if get_tree().current_scene.name != "Main":
		set_process(false)
		self.visible = false
	update_label()

func _process(delta):
	if game_over:
		return

	time_left -= delta

	if time_left <= 0:
		game_over = true
		print("Game Over 💀")
		get_tree().change_scene_to_file("res://LoseEnd.tscn")
		return

	update_label()

func update_label():
	var total_seconds = int(ceil(time_left))
	var min = total_seconds / 60
	var sec = total_seconds % 60
	$Label.text = "%02d:%02d" % [min, sec]
