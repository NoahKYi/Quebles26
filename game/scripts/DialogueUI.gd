extends Control

var type_speed := 0.03
var hold_time := 1.5
@onready var blip_player := $BlipPlayer
var typing := false
var queue := []  # store dialogue entries

# Signal to emit when a dialogue completes
signal dialogue_completed

# Called by DialogueManager
func show_dialogue(text, portrait, speaker):
	queue.append({"text": text, "portrait": portrait, "speaker": speaker})
	
	if not typing:
		_process_queue_async()
	
	# Wait for the next dialogue_completed signal
	await dialogue_completed

# Async queue processor
func _process_queue_async():
	typing = true
	while queue.size() > 0:
		var entry = queue.pop_front()
		
		visible = true
		$Panel/Text.text = ""
		$Panel/TextureRect.texture = entry.portrait
		$Panel/NameLabel.text = entry.speaker if entry.speaker != "" else "Narrator"
		
		# Wait for typewriter to finish
		await _type_text(entry.text)
		await get_tree().create_timer(hold_time).timeout
		
		hide_dialogue()
		
		# Emit completion signal
		dialogue_completed.emit()
	
	typing = false

# Typewriter
func _type_text(text: String):
	for c in text:
		$Panel/Text.text += c
		if c != " ":
			blip_player.play()
		await get_tree().create_timer(type_speed).timeout

func hide_dialogue():
	visible = false

func _ready() -> void:
	visible = false
	DialogueManager.dialogue_ui = self
	print("DialogueUI ready")
