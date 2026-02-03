extends StaticBody2D

@onready var clueNumber = self.get_meta("clue_number")
@onready var nextClue = self.get_meta("next_clue")
var currentRoomNumber = 1
var state = 0 #0 means the investigator should go to a new location, 1 means traveling to a new location, 2 means investigating a location
var timeUntilDoneInvestigatingThisSpot = 0;
var destinationInteractLocation = null;
var destination : Vector2 = Vector2(0,0) #coordinates to wherever the investigator is trying to move (updated by functions go wander around the rooms)
#format for storing where the navigator can go in each room in the following format, also if the clue number is zero then there is nothing to find at that location {roomNumber1: [[Vector2(xCordOfInteractLocation, yCord), clueNumber], [next location], [third location], ...], roomNumber2: [...] ...}
var interactLocations = {1: [[Vector2(1083,1972), 0], [Vector2(1033,132), 2], [Vector2(230,180), 1]]}
var foundClues = []
var alreadyVisited = []
var threshold = 50 #distance the investigator must be within to the destination before the investigator stops moving
var timerUntilDoneInvestigating = null;
func _process(delta: float) -> void:
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

#navigate to a certain room when either the murderer or the player makes a noise
func goToRoom(roomNumber:int):
	
	pass
#slowly wander around a and look for clues
func wanderAroundRoom():
	#walk to a certain part of the room
	var interactLocationsInThisRoom = interactLocations[currentRoomNumber]
	destinationInteractLocation = interactLocationsInThisRoom[randi() % len(interactLocationsInThisRoom)]
	destination = destinationInteractLocation[0] #go to the coords stored in the destinationInteractLocation (index 0 is the coords, index 1 is what clue is at that location (or lack of a clue indicated by value of 0))
	#TODO: Add logic so the investigator doesn't revisit already visited locations
	
	
#go to target destination as determined by destination variable
func goToTargetLocation():
	#TODO: Add code to actually move the invesitgator towards the target avoiding hitting walls or other objects
	
	if self.global_position.distance_to(destination) < threshold:
		state = 2 #set state to investigating (stop at the location and investigate)
		timerUntilDoneInvestigating = Timer.new()
		timerUntilDoneInvestigating.wait_time = randi() % 20 + 100 #TODO: Adjust these time values to something reasonable for how long the investigator spends searching a specific location
		timerUntilDoneInvestigating.start()
		
	pass
	
func investigate():
	if timerUntilDoneInvestigating.get_time_left() > 0:
		#do nothing until the timer runs out
		pass
	else:
		if destinationInteractLocation[1] != 0:
			#found a clue (or false clue)
			#TODO: actually do something once the investigator finds a clue
			pass
		else:
			#didn't find a clue
			alreadyVisited.append(destinationInteractLocation)
			state = 0 #the investigator should go somewhere else
	

			
