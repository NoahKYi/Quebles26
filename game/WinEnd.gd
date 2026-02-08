extends Node2D

func _ready() -> void:
	await get_tree().process_frame
	await show_win_scene()

func show_win_scene() -> void:
	await DialogueManager.show("I think I understand now.", null, "Investigator")
	await DialogueManager.show("At first, it all felt disconnected.", null, "Investigator")
	await DialogueManager.show("But the pieces kept turning up… out of place.", null, "Investigator")
	
	await DialogueManager.show("The medication bottle. Hidden away, but recently moved.", null, "Investigator")
	await DialogueManager.show("A journal. Careful words, careful planning.", null, "Investigator")
	await DialogueManager.show("And the insurance document.", null, "Investigator")
	
	await DialogueManager.show("Individually, they mean nothing.", null, "Investigator")
	await DialogueManager.show("Together… they tell a story.", null, "Investigator")
	
	await DialogueManager.show("This wasn’t an accident.", null, "Investigator")
	await DialogueManager.show("Someone stood to gain from this death.", null, "Investigator")
	await DialogueManager.show("And now I know who.", null, "Investigator")
