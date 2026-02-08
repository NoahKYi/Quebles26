extends Node2D

func _ready() -> void:
	await get_tree().process_frame
	await show_lose_scene()

func show_lose_scene() -> void:
	await DialogueManager.show("…I don’t know anymore.", null, "Investigator")
	await DialogueManager.show("Every lead points somewhere different.", null, "Investigator")
	await DialogueManager.show("Nothing stays where it should. Everything feels… out of place.", null, "Investigator")
	
	await DialogueManager.show("Too many details. Too many contradictions.", null, "Investigator")
	await DialogueManager.show("Some things look important. Others feel planted.", null, "Investigator")
	await DialogueManager.show("I can’t tell which is which.", null, "Investigator")
	
	await DialogueManager.show("Time keeps slipping by.", null, "Investigator")
	await DialogueManager.show("And the truth isn’t getting any clearer.", null, "Investigator")
	
	await DialogueManager.show("If there was something here… I missed it.", null, "Investigator")
	await DialogueManager.show("I can’t keep chasing ghosts.", null, "Investigator")
	await DialogueManager.show("This case is going cold.", null, "Investigator")
