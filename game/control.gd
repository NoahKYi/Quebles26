extends Control


func _ready():
	Reset_Timer()
	_on_timeout()
	

var sec = 0
var min = 0
var defsec = 0 # Default Seconds
var defmin = 5 # Default Minutes

func Reset_Timer():
	sec = defsec
	min = defmin
	
func center_label(delta):
	await get_tree().process_frame  
	var player = $Player
	var label = $Label               
	label.pivot_offset = label.size / 2
	label.global_position = player.position + Vector2(0, -60)

	  # 60px above the player

func _on_timeout():
	if min == 0 and sec == 0: # Game Over
		print("Game Over")
		$Timer.stop()
		return
		
	if sec == 0: # Minute Decreases
		min -= 1
		sec = 59
		upd_script()
	else: # Seconds Decrease
		sec -= 1
		upd_script()
		
func upd_script():
	$Label.text = "%02d:%02d" % [min, sec]
