extends Node2D

@onready var clueNumber = self.get_meta("clue_number")
@onready var nextClue = self.get_meta("next_clue")
@onready var navigation = self.get_node("../Map/Floor/Walkable")
var currentRoomNumber = 1
var state = 0 #0 means the investigator should go to a new location, 1 means traveling to a new location, 2 means investigating a location
var timeUntilDoneInvestigatingThisSpot = 0;
var destinationInteractLocation = null;
var destination : Vector2 = Vector2(0,0) #coordinates to wherever the investigator is trying to move (updated by functions go wander around the rooms)
var nextRoutePoint : Vector2 = self.position #next point along the route to destination generated using the AStarGrid2D in the Map scene
#format for storing where the navigator can go in each room in the following format, also if the clue number is zero then there is nothing to find at that location {roomNumber1: [[Vector2(xCordOfInteractLocation, yCord), clueNumber], [next location], [third location], ...], roomNumber2: [...] ...}
var interactLocations = {1: [[Vector2(100,100), 0], [Vector2(200,200), 2], [Vector2(200,150), 1]]}
var foundClues = []
var alreadyVisited = []
var threshold = 5 #distance the investigator must be within to the destination before the investigator stops moving
var timerUntilDoneInvestigating = null;
var speed = 10;
func _process(_delta: float) -> void:
	#figure out what room the investigator is currently in, can place area2Ds around the map and check if the investigator is overlapping one of them to determine the room
	#roomNumber = currentRoom
	
	
	#logic for what the investigator should do
	match state:
		0:
			wanderAroundRoom()
		1:
			goToTargetLocation()
		2:
			investigate()
			#do nothing until a timer runs out which will call a function to reveal the results of investigating a certain location (either will find nothing, a clue, or a false clue)

func _physics_process(delta: float) -> void:
	self.position += self.position.direction_to(nextRoutePoint) * speed * delta #move the player a bit towards nextRoutePoint (based on speed and time between frames)
	if (state == 1): #only move if the investigator should be moving to a new location
		if (self.position.distance_to(nextRoutePoint) < threshold):
			#recalculate the path to the destination and set the next point as nextRoutePoint
			var path = navigation.get_ideal_path(self.position, destination)
			
			if (len(path) > 1):
				nextRoutePoint = path[1]
			else:
				print("arrived")
				alreadyVisited.push_back(destinationInteractLocation) #so that the investigator doesn't re-investigate the same spots
				state = 2
				startInvestigating()
#navigate to a certain room when either the murderer or the player makes a noise
func goToRoom(roomNumber : int):
	
	pass
#slowly wander around a and look for clues
func wanderAroundRoom():
	#walk to a certain part of the room
	var interactLocationsInThisRoom = interactLocations[currentRoomNumber]

	var newPotentialSpot = interactLocationsInThisRoom[randi() % len(interactLocationsInThisRoom)]
	while (newPotentialSpot in alreadyVisited): #loop until the new spot is different than the already visited spots
		newPotentialSpot = interactLocationsInThisRoom[randi() % len(interactLocationsInThisRoom)]
		print("attempting to locate new spot to investigate")
	destinationInteractLocation = newPotentialSpot
		
	destination = destinationInteractLocation[0] #go to the coords stored in the destinationInteractLocation (index 0 is the coords, index 1 is what clue is at that location (or lack of a clue indicated by value of 0))
	#TODO: Add logic so the investigator doesn't revisit already visited locations
	
	state = 1
	
	
#go to target destination as determined by destination variable
func goToTargetLocation():
	#TODO: Add code to actually move the invesitgator towards the target avoiding hitting walls or other objects
	if self.global_position.distance_to(destination) < threshold && state == 1:
		state = 2 #set state to investigating (stop at the location and investigate)
		startInvestigating()
		
	
	
#start a timer so that the investigator will investigate until it ends
func startInvestigating():
	timerUntilDoneInvestigating = Timer.new()
	timerUntilDoneInvestigating.set_wait_time(randi() % 10 + 20) #set the time until the investigator is done investigating a spot to a random amount between 20-30 seconds
	get_tree().root.add_child(timerUntilDoneInvestigating)
	timerUntilDoneInvestigating.start()
	
func investigate():
	#print("investigating for " + str(timerUntilDoneInvestigating.get_time_left()) + " more seconds")
	if timerUntilDoneInvestigating.get_time_left() > 0:
		#do nothing until the timer runs out
		pass
	else:
		if destinationInteractLocation[1] != 0:
			#found a clue (or false clue)
			foundClues.push_back(destinationInteractLocation[1]) #add the found clue to the list of found clues
			state = 0
			print("found clue " + str(destinationInteractLocation[1]))
			#TODO: actually do something once the investigator finds a clue
			pass
		else:
			#didn't find a clue
			alreadyVisited.append(destinationInteractLocation)
			state = 0 #the investigator should go somewhere else
			print("Didn't find a clue")
	

			
