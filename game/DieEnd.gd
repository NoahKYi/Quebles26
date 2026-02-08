extends Node2D

func _ready() -> void:
	await get_tree().process_frame
	await show_win_scene()

func show_win_scene() -> void:
	await DialogueManager.show("You’re gone. Out of energy.", null, "???")
	await DialogueManager.show("That was the last push he needed.", null, "???")

	await DialogueManager.show("Without you, every lead collapses into noise.", null, "???")
	await DialogueManager.show("Nothing stands out. Nothing points forward.", null, "???")

	await DialogueManager.show("He’ll never know how close he was.", null, "???")
	await DialogueManager.show("Or that you were ever there.", null, "???")

	await DialogueManager.show("The truth stays buried.", null, "???")
