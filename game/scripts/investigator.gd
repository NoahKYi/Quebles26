extends Node2D

@onready var clueNumber = self.get_meta("clue_number")
@onready var nextClue = self.get_meta("next_clue")
@onready var navigation = self.get_node("../Map/Floor/Walkable")
var state = 0 #0 means the investigator should go to a new location, 1 means traveling to a new location, 2 means investigating a location
var timeUntilDoneInvestigatingThisSpot = 0;
var destinationInteractLocation = null;
@onready var destination : Vector2 = self.global_position #coordinates to wherever the investigator is trying to move (updated by functions go wander around the rooms)
@onready var nextRoutePoint : Vector2 = self.global_position #next point along the route to destination generated using the AStarGrid2D in the Map scene
#format for storing where the navigator can go in the following format, also if the clue number is zero then there is nothing to find at that location[[Vector2(xCordOfInteractLocation, yCord), clueNumber], [next location], [third location]...]
var interactLocations = []
var foundClues = []
var alreadyVisited = []
var threshold = 4 #distance the investigator must be within to the destination before the investigator stops moving
var timerUntilDoneInvestigating = null;
var speed = 20
var path = []

func _ready() -> void:
	populateInteractLocations()
	
func _process(_delta: float) -> void:
	#figure out what room the investigator is currently in, can place area2Ds around the map and check if the investigator is overlapping one of them to determine the room
	#roomNumber = currentRoom
	
	print("state: " + str(state))
	#logic for what the investigator should do
	match state:
		0:
			wanderAroundHouse()
		1:
			#goToTargetLocation() #this is now handled in _physics_process()
			pass
		2:
			investigate()
			#do nothing until a timer runs out which will call a function to reveal the results of investigating a certain location (either will find nothing, a clue, or a false clue)

func _physics_process(delta: float) -> void:
	self.global_position += self.global_position.direction_to(nextRoutePoint) * speed * delta #move the player a bit towards nextRoutePoint (based on speed and time between frames)
	if (state == 1): #only move if the investigator should be moving to a new location
		print("nextRoutePoint: " + str(nextRoutePoint))
		if (self.global_position.distance_to(nextRoutePoint) < threshold):
			#recalculate the path to the destination and set the next point as nextRoutePoint
			
			print("len(path): " + str(len(path)))
			print(path)
			if (len(path) > 1):
					nextRoutePoint = path[1]
					path = path.slice(1)
			else:
				print("arrived")
				alreadyVisited.push_back(destinationInteractLocation) #so that the investigator doesn't re-investigate the same spots
				state = 2
				startInvestigating()
				
func populateInteractLocations():
	for node in get_node("../OtherInvestigationSpotsWithoutClues").get_children(): #add the spots where the investigator finds nothing
		interactLocations.append([node.global_position, 0])
		
	for node in get_node("../Clues").get_children(): #add the actual clues and false clues
		interactLocations.append([node.global_position, node.get_meta("clue_number")])

#slowly wander around a and look for clues
func wanderAroundHouse():
	var newPotentialSpot = interactLocations[randi() % len(interactLocations)]
	while (newPotentialSpot in alreadyVisited): #loop until the new spot is different than the already visited spots
		newPotentialSpot = interactLocations[randi() % len(interactLocations)]
		print("attempting to locate new spot to investigate")
	destinationInteractLocation = newPotentialSpot
	print("new spot: " + str(destinationInteractLocation))
	print("old spots: " + str(alreadyVisited))
	destination = destinationInteractLocation[0] #go to the coords stored in the destinationInteractLocation (index 0 is the coords, index 1 is what clue is at that location (or lack of a clue indicated by value of 0))
	#TODO: Add logic so the investigator doesn't revisit already visited locations
	path = navigation.get_ideal_path(self.global_position, destination)
	state = 1
	
	
		
	
	
#start a timer so that the investigator will investigate until it ends
func startInvestigating():
	timerUntilDoneInvestigating = Timer.new()
	timerUntilDoneInvestigating.one_shot = true #don't reset the remaining time automatically once the timer finishes
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
	

			
