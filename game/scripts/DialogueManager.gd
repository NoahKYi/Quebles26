extends Node

var dialogue_ui

func show(text, portrait, name):
	if dialogue_ui:
		print("test2")
		await dialogue_ui.show_dialogue(text, portrait, name)
