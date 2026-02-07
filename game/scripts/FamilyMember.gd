extends CharacterBody2D

@export var display_name: String
@export var portrait: Texture2D

func _ready() -> void:
	# Add to the family_members group so the clue can find this NPC
	add_to_group("family_members")

func say(key: String):
	print("test")
	if not DialogueLines.LINES.has(key):
		return
	print(DialogueLines.LINES[key])
	DialogueManager.show(DialogueLines.LINES[key], portrait, display_name)

func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		say("found_item")
