extends Control
var type_speed := 0.03
var hold_time := 1.5
var punctuation_pause := 0.25
@onready var blip_player := $BlipPlayer
@onready var text_label := $Panel/Text  # Reference to the text label
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
		text_label.text = ""
		$Panel/TextureRect.texture = entry.portrait
		$Panel/NameLabel.text = entry.speaker if entry.speaker != "" else "Narrator"
		
		await _type_text(entry.text)
		await get_tree().create_timer(hold_time).timeout
		
		hide_dialogue()
		dialogue_completed.emit()
	
	typing = false

func _type_text(text: String):
	for c in text:
		text_label.text += c
		
		# Auto-scale if text is getting too long
		_adjust_text_scale()
		
		if c != " ":
			blip_player.play()
		
		var delay := type_speed
		if c in [".", "!", "?"]:
			delay += punctuation_pause
		
		await get_tree().create_timer(delay).timeout

func _adjust_text_scale():
	"""Automatically scale down text if it overflows"""
	# Get the text's actual size
	var text_size = text_label.get_minimum_size()
	var container_size = text_label.size
	
	# If text is overflowing, scale it down
	if text_size.y > container_size.y:
		var scale_factor = container_size.y / text_size.y
		text_label.add_theme_font_size_override("font_size", int(text_label.get_theme_font_size("font_size") * scale_factor * 0.95))
	
func hide_dialogue():
	visible = false
	# Reset text scale when hiding
	text_label.remove_theme_font_size_override("font_size")

func _ready() -> void:
	visible = false
	await get_tree().process_frame
	DialogueManager.dialogue_ui = self
	print("DialogueUI ready")
