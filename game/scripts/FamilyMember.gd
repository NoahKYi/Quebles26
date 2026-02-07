extends CharacterBody2D

@export var display_name: String
@export var portrait: Texture2D

func say(key: String):
	print("test")
	if not DialogueLines.LINES.has(key):
		return
	print(DialogueLines.LINES[key])
	DialogueManager.show(DialogueLines.LINES[key], portrait, display_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		say("found_item")
