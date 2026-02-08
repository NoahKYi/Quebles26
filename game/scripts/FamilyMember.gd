extends CharacterBody2D

@export var display_name: String
@export var portrait: Texture2D
@onready var navigation = self.get_node("../../Map/Floor/Walkable")
@onready var investigator = self.get_node("../../Investigator")
@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D

var state = 0 #0 means should wander somewhere, 1 means walking to somewhere, 2 means arrived somewhere
var path = []
var nextRoutePoint = self.global_position
const speed = 15
const threshold = 20
var timerUntilWanderAgain = null;
var positionToTellInvestigatorAbout = Vector2(0,0)
var last_direction = Vector2.DOWN  # Track the last movement direction

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
			checkIfShouldWanderAgain() #do nothing until a timeout finishes
		3:
			#state is walking to investigator
			#handled in _physics_process()
			pass
		4:
			#trigger investigator to look where this NPC heard a sound
			tellInvestigator()
			
func _physics_process(delta: float) -> void:
	if (state == 1 or state == 3): #only move if the family member should be moving to a new location
		var direction = self.get_node("..").global_position.direction_to(nextRoutePoint)
		self.get_node("..").global_position += direction * speed * delta #move the family member a bit towards nextRoutePoint (based on speed and time between frames)
		
		# Update animation based on movement direction
		update_animation(direction)
	
		#print("nextRoutePoint: " + str(nextRoutePoint) + " distance: " + str(self.get_node("..").global_position.distance_to(nextRoutePoint)))
		if (self.get_node("..").global_position.distance_to(nextRoutePoint) < threshold):
			#recalculate the path to the destination and set the next point as nextRoutePoint
			
			#print("len(path): " + str(len(path)))
			#print(path)
			if (len(path) > 1):
					nextRoutePoint = path[1]
					path = path.slice(1)
			else:
				print("family member arrived")
				animated_sprite.stop()  # Stop animation when arrived
				if (state == 1):
					state = 2
					waitUntilWanderTimeout()
				elif state == 3:
					state = 4
	else:
		# Stop animation when not moving
		animated_sprite.stop()

func update_animation(direction: Vector2):
	# Determine which direction is dominant
	if abs(direction.x) > abs(direction.y):
		# Horizontal movement
		if direction.x > 0:
			animated_sprite.play("walk_right")
			last_direction = Vector2.RIGHT
		else:
			animated_sprite.play("walk_left")
			last_direction = Vector2.LEFT
	else:
		# Vertical movement
		if direction.y > 0:
			animated_sprite.play("walk_down")
			last_direction = Vector2.DOWN
		else:
			animated_sprite.play("walk_up")
			last_direction = Vector2.UP

#slowly wander around a and look for clues
func wanderAroundHouse():
	path = navigation.get_path_to_random_spot(self.get_node("..").global_position)
	if (len(path)>0):
		nextRoutePoint = path[0]
		#print("length of family member " + get_node("..").name + " path is 0, this is not good, but it seems to work any way, fix if we have time")
	else:
		nextRoutePoint = self.get_node("..").global_position
	#print("newPath: " + str(path))
	state = 1
	
func waitUntilWanderTimeout():
	timerUntilWanderAgain = Timer.new()
	timerUntilWanderAgain.one_shot = true #don't reset the remaining time automatically once the timer finishes
	timerUntilWanderAgain.set_wait_time(randi() % 5 + 5) #set the time until the family member wanders again to a random amount between 5-10 seconds
	get_tree().root.add_child(timerUntilWanderAgain)
	timerUntilWanderAgain.start()
	
func checkIfShouldWanderAgain():
	if timerUntilWanderAgain.get_time_left() > 0:
		#do nothing until the timer runs out
		pass
	else:
		print("wandering again")
		state = 0 #set state to should wander

func walkToInvestigator(positionOfSound : Vector2):
	positionToTellInvestigatorAbout = positionOfSound
	
	path = navigation.get_ideal_path(self.get_node("..").global_position, investigator.global_position)
	if (len(path)>0):
		nextRoutePoint = path[0]
		#print("length of family member " + get_node("..").name + " path is 0, this is not good, but it seems to work any way, fix if we have time")
	else:
		nextRoutePoint = self.get_node("..").global_position
	#print("newPath: " + str(path))
	timerUntilWanderAgain=null #clear the wandering timer
	state = 3
	
func tellInvestigator():
	self.say("found_something_look_over_there")
	investigator.investigate_sound(positionToTellInvestigatorAbout)
	state = 2
	waitUntilWanderTimeout()
	
	

func respond_to_laptop_question():
	say("son_respond_to_laptop_question")
	investigator.investigate_laptop_again_son()

func respond_to_journal_question():
	var found_clues = investigator.foundClues
	if (4 not in found_clues):
		say("daughter_respond_to_journal_question_computer_redirect")
		investigator.investigate_laptop_after_daughter_request()
	elif (2 not in found_clues):
		say("daughter_respond_to_journal_question_will_redirect")
		investigator.investigate_will_after_daughter_request()
	else:
		say("daughter_respond_to_journal_question_give_up")
		#player wins
