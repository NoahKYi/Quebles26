extends Control

var type_speed := 0.03
var hold_time := 1.5
var punctuation_pause := 0.25 # 👈 pause after periods etc

@onready var blip_player := $BlipPlayer
var typing := false
var queue := []

signal dialogue_completed

func show_dialogue(text, portrait, speaker):
	queue.append({"text": text, "portrait": portrait, "speaker": speaker})
	
	if not typing:
		_process_queue_async()
	
	await dialogue_completed

func _process_queue_async():
	typing = true
	while queue.size() > 0:
		var entry = queue.pop_front()
		
		visible = true
		$Panel/Text.text = ""
		$Panel/TextureRect.texture = entry.portrait
		$Panel/NameLabel.text = entry.speaker if entry.speaker != "" else "Narrator"
		
		await _type_text(entry.text)
		await get_tree().create_timer(hold_time).timeout
		
		hide_dialogue()
		dialogue_completed.emit()
	
	typing = false

# 💀 typewriter with dramatic sigma pauses
func _type_text(text: String):
	for c in text:
		$Panel/Text.text += c
		
		if c != " ":
			blip_player.play()
		
		var delay := type_speed
		if c in [".", "!", "?"]:
			delay += punctuation_pause  # 👻 dramatic pause
		
		await get_tree().create_timer(delay).timeout

func hide_dialogue():
	visible = false

func _ready() -> void:
	visible = false
	# Wait one frame to ensure DialogueManager autoload is ready
	await get_tree().process_frame
	DialogueManager.dialogue_ui = self
	print("DialogueUI ready")
