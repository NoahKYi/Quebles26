extends Node2D

@onready var screen_block_label = $ScreenBlock/Label
@onready var screen_block_button = $ScreenBlock/Button
@onready var investigator_portrait = preload("res://Assets/Ninja Adventure - Asset Pack/Actor/Characters/Investigator/Faceset.png")

func _ready() -> void:
	# Hide the label and button at start
	if screen_block_label:
		screen_block_label.visible = false
	if screen_block_button:
		screen_block_button.visible = false
	
	await get_tree().process_frame
	await show_lose_scene()

func show_lose_scene() -> void:
	await DialogueManager.show("…I don't know anymore.", investigator_portrait, "Investigator")
	await DialogueManager.show("Every clue points somewhere different.", investigator_portrait, "Investigator")
	await DialogueManager.show("Everything feels… out of place.", investigator_portrait, "Investigator")
	
	await DialogueManager.show("Too many conflicting stories. Some things seem planted.", investigator_portrait, "Investigator")
	await DialogueManager.show("Time is slipping by. I'm not getting any closer to finding the truth.", investigator_portrait, "Investigator")	
	await DialogueManager.show("If there was something here… I missed it.", investigator_portrait, "Investigator")
	await DialogueManager.show("I can't keep chasing ghosts.", investigator_portrait, "Investigator")
	await DialogueManager.show("This case is going cold.", investigator_portrait, "Investigator")
	
	# Show the label and button after all dialogue is done
	if screen_block_label:
		screen_block_label.visible = true
	if screen_block_button:
		screen_block_button.visible = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main.tscn")
