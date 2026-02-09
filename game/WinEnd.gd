extends Node2D
@onready var screen_block_label = $ScreenBlock/Label
@onready var investigator_portrait = preload("res://Assets/Ninja Adventure - Asset Pack/Actor/Characters/Investigator/Faceset.png")

func _ready() -> void:
	# Hide the label at start
	if screen_block_label:
		screen_block_label.visible = false
	
	await get_tree().process_frame
	await show_win_scene()

func show_win_scene() -> void:
	await DialogueManager.show("I think I understand now.", investigator_portrait, "Investigator")
	await DialogueManager.show("At first, it all felt disconnected.", investigator_portrait, "Investigator")
	await DialogueManager.show("But all these clues... out of place... are coming together", investigator_portrait, "Investigator")
	
	await DialogueManager.show("The medication bottle. Empty.", investigator_portrait, "Investigator")
	await DialogueManager.show("A journal. Careful words, careful planning.", investigator_portrait, "Investigator")
	await DialogueManager.show("The computer. A planted search history.", investigator_portrait, "Investigator")
	await DialogueManager.show("And the insurance document.", investigator_portrait, "Investigator")
	
	await DialogueManager.show("Together… they tell a story.", investigator_portrait, "Investigator")
	
	await DialogueManager.show("This wasn't an accident.", investigator_portrait, "Investigator")
	await DialogueManager.show("Someone stood to gain from this death.", investigator_portrait, "Investigator")
	await DialogueManager.show("And now I know who.", investigator_portrait, "Investigator")
	
	# Show the label after all dialogue is done
	if screen_block_label:
		screen_block_label.visible = true
