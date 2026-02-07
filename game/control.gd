extends Control

var sec = 0
var min = 0
var defsec = 0 # Default Seconds
var defmin = 5 # Default Minutes


func _ready():
	Reset_Timer()
	_on_timeout()
	
func Reset_Timer():
	sec = defsec
	min = defmin
	
func _on_timeout():
	if min == 0 and sec == 0:
		print("Game Over")
		$Timer.stop()
		return
		
	if sec == 0:
		min -= 1
		sec = 59
		return
		
	else:
		sec -= 1
		return
		
	$Label.text = "%02d:%02d" % [min, sec]
