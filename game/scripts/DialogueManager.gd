extends Node

var dialogue_ui = null

func show(text, portrait, name):
	if dialogue_ui:
		print("test2")
		await dialogue_ui.show_dialogue(text, portrait, name)
	else:
		push_error("DialogueUI not registered yet!")
