extends Node2D

@onready var screen_block = $ScreenBlock
@onready var screen_block_rect = $ScreenBlock/ColorRect  # or whatever the visual node is called

var temp_skip = false

func _ready() -> void:
	screen_block.visible = true
	screen_block_rect.modulate.a = 1.0  # Ensure it starts fully opaque
	await get_tree().process_frame  # let the engine actually draw the black screen
	if !temp_skip:
		await show_intro()
	await fade_out_screen_block()  # Fade out instead of instant hide

func show_intro() -> void:
	await DialogueManager.show("Your daughter has killed you...", null, "???")
	await DialogueManager.show("Now you are a ghost trying to help your family find out the truth.", null, "???")
	await DialogueManager.show("Possess the clues and try to help your family alert the investigator.", null, "???")
	await DialogueManager.show("The clues will point to the murderer. Avoid the false ones.", null, "???")
	await DialogueManager.show("And hurry, the investigator will give up once the timer runs out.", null, "???")
	await DialogueManager.show("Your energy is limited. Possess too much and you'll disappear forever.", null, "???")

# Fade out the screen block
func fade_out_screen_block() -> void:
	var fade_duration = 1.5  # seconds
	var tween = create_tween()
	tween.tween_property(screen_block_rect, "modulate:a", 0.0, fade_duration)
	await tween.finished
	screen_block.visible = false  # Hide it completely after fade

func _process(delta: float) -> void:
	pass
