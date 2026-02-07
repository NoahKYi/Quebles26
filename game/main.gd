extends Node2D

@onready var screen_block = $ScreenBlock
@onready var screen_block_rect = $ScreenBlock/ColorRect  # or whatever the visual node is called

func _ready() -> void:
	screen_block.visible = true
	screen_block_rect.modulate.a = 1.0  # Ensure it starts fully opaque
	await get_tree().process_frame  # let the engine actually draw the black screen
	await show_intro()
	await fade_out_screen_block()  # Fade out instead of instant hide

# Async function for the intro
func show_intro() -> void:
	await DialogueManager.show("You shouldn't be here… or rather, you shouldn't be alive.", null, "Narrator")
	await DialogueManager.show("Xavier… he ended your life. And now… you've been given a second chance.", null, "Narrator")
	await DialogueManager.show("The world feels… off. You can pass through walls. You can move objects without touching them.", null, "Narrator")
	await DialogueManager.show("But be careful. Every action has consequences… subtle ones.", null, "Narrator")
	await DialogueManager.show("Hidden clues are scattered across the house: bottles, documents, journals. Some reveal the truth, others mislead.", null, "Narrator")
	await DialogueManager.show("Move the clues wisely. The investigator is searching. If they notice something out of place, it will help them piece together the case.", null, "Narrator")
	await DialogueManager.show("Strategically guide the investigator to the real murderer… and make them pay for what they did.", null, "Narrator")
	await DialogueManager.show("Press SHIFT to walk through walls. Press Q to pick up and place objects. Push E to interact with items. Your time and energy as a soul is limited, so act wisely.", null, "Narrator")

# Fade out the screen block
func fade_out_screen_block() -> void:
	var fade_duration = 1.5  # seconds
	var tween = create_tween()
	tween.tween_property(screen_block_rect, "modulate:a", 0.0, fade_duration)
	await tween.finished
	screen_block.visible = false  # Hide it completely after fade

func _process(delta: float) -> void:
	pass
