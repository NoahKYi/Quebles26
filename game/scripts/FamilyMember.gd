extends CharacterBody2D

@export var display_name: String
@export var portrait: Texture2D
@onready var navigation = self.get_node("../../Map/Floor/Walkable")
var state = 0 #0 means should wander somewhere, 1 means walking to somewhere, 2 means arrived somewhere
var path = []
var nextRoutePoint = self.global_position
const speed = 15
const threshold = 20
func _ready() -> void:
	# Add to the family_members group so the clue can find this NPC
	add_to_group("family_members")

func say(key: String):
	print(DialogueLines)
	if not DialogueLines.LINES.has(key):
		return
	print(DialogueLines.LINES[key])
	DialogueManager.show(DialogueLines.LINES[key], portrait, display_name)

func _process(delta: float) -> void:
	match state:
		0:
			wanderAroundHouse()
		1:
			#movement is handled in physics process
			pass
		2:
			pass #do nothing until a timeout finishes
			
func _physics_process(delta: float) -> void:
	if (state == 1): #only move if the family member should be moving to a new location
		self.global_position += self.global_position.direction_to(nextRoutePoint) * speed * delta #move the family member a bit towards nextRoutePoint (based on speed and time between frames)
	
		print("nextRoutePoint: " + str(nextRoutePoint))
		if (self.global_position.distance_to(nextRoutePoint) < threshold):
			#recalculate the path to the destination and set the next point as nextRoutePoint
			
			print("len(path): " + str(len(path)))
			print(path)
			if (len(path) > 1):
					nextRoutePoint = path[1]
					path = path.slice(1)
			else:
				print("family member arrived")
				state = 2
				waitUntilWanderTimeout()
#slowly wander around a and look for clues
func wanderAroundHouse():
	path = navigation.get_path_to_random_spot(self.global_position)
	
	state = 1
func waitUntilWanderTimeout():
	pass
func _input(event):
	if event.is_action_pressed("ui_accept"):
		say("found_item")
