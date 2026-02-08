extends Node

var dialogue_ui = null

func show(text, portrait, name):
	if dialogue_ui:
		await dialogue_ui.show_dialogue(text, portrait, name)
	else:
		push_error("DialogueUI not registered yet!")
