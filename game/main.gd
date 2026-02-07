extends Node2D

@onready var screen_block = $ScreenBlock
@onready var screen_block_rect = $ScreenBlock/ColorRect  # or whatever the visual node is called

var temp_skip = true

func _ready() -> void:
	screen_block.visible = true
	screen_block_rect.modulate.a = 1.0  # Ensure it starts fully opaque
	await get_tree().process_frame  # let the engine actually draw the black screen
	if !temp_skip:
		await show_intro()
	await fade_out_screen_block()  # Fade out instead of instant hide

func show_intro() -> void:
	await DialogueManager.show("You’re dead. But you’re still here.", null, "???")
	await DialogueManager.show("Your death wasn’t an accident.", null, "???")
	await DialogueManager.show("Now you linger as a soul - unseen, unsettled, out of place.", null, "???")
	await DialogueManager.show("You can slip through walls. You can possess objects.", null, "???")
	await DialogueManager.show("When things shift, people notice. Something feels… out of place.", null, "???")
	await DialogueManager.show("Not everything tells the truth. Some things are meant to mislead.", null, "???")
	await DialogueManager.show("An investigator is searching. Guide them carefully.", null, "???")
	await DialogueManager.show("SHIFT: pass through walls. Q: possess objects. E: interact.", null, "???")

# Fade out the screen block
func fade_out_screen_block() -> void:
	var fade_duration = 1.5  # seconds
	var tween = create_tween()
	tween.tween_property(screen_block_rect, "modulate:a", 0.0, fade_duration)
	await tween.finished
	screen_block.visible = false  # Hide it completely after fade

func _process(delta: float) -> void:
	pass
