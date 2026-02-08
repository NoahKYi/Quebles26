extends Node2D

var music = preload("res://Screens/title.mp3")
func _ready():
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = music
	player.pitch_scale = 0.5
	player.connect("finished", Callable(self,"_on_loop_sound").bind(player))
	player.play()
func _on_loop_sound(player):
	player.stream_paused = false


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main.tscn")
