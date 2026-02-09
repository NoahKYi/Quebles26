extends Node2D

@onready var screen_block_label = $ScreenBlock/Label
@onready var screen_block_button = $ScreenBlock/Button

func _ready() -> void:
	# Hide the label and button at start
	if screen_block_label:
		screen_block_label.visible = false
	if screen_block_button:
		screen_block_button.visible = false
	
	await get_tree().process_frame
	await show_win_scene()

func show_win_scene() -> void:
	await DialogueManager.show("Your energy is gone... and so are you.", null, "???")
	await DialogueManager.show("You were close. But without your help, the investigator gave up.", null, "???")
	await DialogueManager.show("Too many clues, too many conflicting stories.", null, "???")
	await DialogueManager.show("You disappear without a trace. Forever.", null, "???")
	await DialogueManager.show("The truth stays buried.", null, "???")
	
	# Show the label and button after all dialogue is done
	if screen_block_label:
		screen_block_label.visible = true
	if screen_block_button:
		screen_block_button.visible = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main.tscn")
