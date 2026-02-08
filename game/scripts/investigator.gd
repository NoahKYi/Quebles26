extends Node2D

@onready var clueNumber = self.get_meta("clue_number")
@onready var nextClue = self.get_meta("next_clue")

@onready var navigation = self.get_node("/root/Main/Map/Floor/Walkable")

@onready var daughter = self.get_node("/root/Main/Daughter/CharacterBody2D")
@onready var son = self.get_node("/root/Main/Son/CharacterBody2D")
@onready var clock = self.get_node("/root/UI/Countdown")

@export var display_name: String
@export var portrait: Texture2D
var state = 0 #0 means the investigator should go to a new location, 1 means traveling to a new location, 2 means investigating a location
var timeUntilDoneInvestigatingThisSpot = 0;
var destinationInteractLocation = null;
@onready var destination : Vector2 = self.global_position #coordinates to wherever the investigator is trying to move (updated by functions go wander around the rooms)
@onready var nextRoutePoint : Vector2 = self.global_position #next point along the route to destination generated using the AStarGrid2D in the Map scene
#format for storing where the navigator can go in the following format, also if the clue number is zero then there is nothing to find at that location[[Vector2(xCordOfInteractLocation, yCord), clueNumber], [next location], [third location]...]
var interactLocations = []
var foundClues = []
var alreadyVisited = []
var threshold = 20 #distance the investigator must be within to the destination before the investigator stops moving
var timerUntilDoneInvestigating = null;
var speed = 20
var path = []
var daughterSaidInvestigateLaptop = false
var daughterSaidInvestigateWill = false
var sonSaidInvestigateLaptopAgain = false
var foundMedicineBottle = false
var foundJournal = false
var foundWill = false

func _ready() -> void:
	for node in get_node("/root/Main/OtherInvestigationSpotsWithoutClues").get_children(): #add the spots where the investigator finds nothing
		interactLocations.append([node.global_position, 0])
	for node in get_node("/root/Main/Clues").get_children(): #add the actual clues and false clues
		interactLocations.append([node.get_node("TargetSpot").global_position, node.get_meta("clue_number")])

func _process(_delta: float) -> void:
	#ALL TIMER CODE
	if (timerUntilDoneInvestigating and timerUntilDoneInvestigating.time_left > 0):
		var time_left = int(timerUntilDoneInvestigating.time_left)
		$Label.text = "%02d" % time_left
	
		
	if timerUntilDoneInvestigating == null or timerUntilDoneInvestigating.time_left == 0:
		$Label.text = "  "
	
	# When the investigator runs out of time, change scene to game over

	
	print("investigator state: " + str(state))
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
		3:
			#state is going to sound (told by NPC)
			#handled by _physics_process()
			pass
		5:
			#going to daughter to ask about journal
			#handled by _physics_process
			pass
		7:
			#going to investigate laptop after asked by daughter
			#handled by _physics_process
			pass
		9:
			#going to investigate will after asked by daughter
			#handled by _physics_process
			pass
		11:
			#going to question son after investigating laptop
			#handled by _physics_process
			pass
		13:
			#going to investigate laptop after talking to son
			#handled by _physics_process
			pass
		
func _physics_process(delta: float) -> void:
	if (state == 1 or state == 3 or state == 5 or state == 7 or state == 9 or state == 11 or state == 13): #only move if the investigator should be moving to a new location
		self.global_position += self.global_position.direction_to(nextRoutePoint) * speed * delta #move the player a bit towards nextRoutePoint (based on speed and time between frames)
	
		#print("nextRoutePoint: " + str(nextRoutePoint))
		if (self.global_position.distance_to(nextRoutePoint) < threshold):
			#recalculate the path to the destination and set the next point as nextRoutePoint
			
			#print("len(path): " + str(len(path)))
			#print(path)
			if (len(path) > 1):
					nextRoutePoint = path[1]
					path = path.slice(1)
			else:
				print("arrived")
				
				if (state == 1): #arrived at investigation spot, start investigating
					state = 2
				elif state == 3: #arrived at location of sound, now go to the closest investigation spot
					state = 0
				elif state == 5:
					if (self.global_position.distance_to(daughter.global_position) > 40):
						ask_daughter_about_journal() #the daughter moved, go to their new position
					else:
						say("question_daugher_about_journal")
						daughter.respond_to_journal_question()
				elif state == 7:
					state = 0
				elif state == 9:
					state = 0
				elif state == 11:
					if (self.global_position.distance_to(son.global_position) < threshold):
						ask_son_about_laptop() #the son moved, go to their new position
					else:
						say("question_son_about_laptop")
						son.respond_to_laptop_question()
				elif state == 13:
					state = 0
				startInvestigating()

func say(key: String):
	print(DialogueLines)
	if not DialogueLines.LINES.has(key):
		return
	print(DialogueLines.LINES[key])
	DialogueManager.show(DialogueLines.LINES[key], portrait, display_name)



func wanderAroundHouse():#slowly wander around a and look for clues
	
	var nonVisitedLocations = []
	for spot in interactLocations:
		if spot not in alreadyVisited:
			nonVisitedLocations.append(spot)
	
	#determine the closeset next spot to search
	print("attempting to locate new spot to investigate")
	var newPotentialSpot = nonVisitedLocations[randi() % len(nonVisitedLocations)]
	for spot in nonVisitedLocations:
		if self.global_position.distance_to(spot[0]) < self.global_position.distance_to(newPotentialSpot[0]):
			newPotentialSpot = spot
	
	
	
	destinationInteractLocation = newPotentialSpot
	print("new spot: " + str(destinationInteractLocation))
	print("old spots: " + str(alreadyVisited))
	destination = destinationInteractLocation[0] #go to the coords stored in the destinationInteractLocation (index 0 is the coords, index 1 is what clue is at that location (or lack of a clue indicated by value of 0))
	path = navigation.get_ideal_path(self.global_position, destination)

	state = 1
	
	
		
	
	
#start a timer so that the investigator will investigate until it ends
func startInvestigating():
	timerUntilDoneInvestigating = Timer.new() # Time at single spot
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
			
			alreadyVisited.append(destinationInteractLocation)
			state = 0
			var clue_number = destinationInteractLocation[1]
			print("found clue " + str(clue_number))
			match clue_number:
				1: #medicine bottle
					foundMedicineBottle = true;
					if (foundJournal):
						say("found_clue_1_after_journal")
						if (foundWill):
							say("solved_murder_medicine_last")
							playerWins()
					else:
						say("found_clue_1")
				2: #will
					foundWill = true
					if (not daughterSaidInvestigateWill):
						say("found_clue_2")
					else:
						if (!foundMedicineBottle):
							say("found_clue_2_after_daughter_asked_no_medicine_bottle")
						else:
							say("solved_murder_will_last")
							playerWins()
							
				3: #journal
					foundJournal = true
					say("found_clue_3")
					ask_daughter_about_journal()
				4: #laptop
					if (4 in foundClues):
						
						foundClues.push_back(5)
						if (daughterSaidInvestigateLaptop):
							
							if (foundMedicineBottle):
								say("daughter_guilty_and_tried_framing_son")
								playerWins()
							else:
								say("daughter_guilty_and_tried_framing_son_but_no_death_weapon")
						else:
							say("found_clue_4_again")
							
					else:
						say("found_clue_4")
						ask_son_about_laptop()
					
			foundClues.push_back(destinationInteractLocation[1]) #add the found clue to the list of found clues
			#TODO: actually do something once the investigator finds a clue
			pass
		else:
			#didn't find a clue
			alreadyVisited.append(destinationInteractLocation)
			state = 0 #the investigator should go somewhere else
			print("Didn't find a clue")

func playerWins():
	print("Player won")
	pass
func ask_daughter_about_journal():
	
	print("going to ask daughter about journal")
	timerUntilDoneInvestigating = null #clear investigation timer (if the investigator was investigating they should immeditely go to this new position)
	path = navigation.get_ideal_path(self.global_position, daughter.global_position)
	state = 5
	print(path)
	if (len(path)>0):
		nextRoutePoint = path[0]
#go to a sound when told by an npc

func investigate_laptop_after_daughter_request():
	say("i_will_go_investigate_the_laptop")
	print("going to investigate laptop")
	timerUntilDoneInvestigating = null #clear investigation timer (if the investigator was investigating they should immeditely go to this new position)
	path = navigation.get_ideal_path(self.global_position, self.get_node("../Clues/ComputerWithPlantedSearchHistory").global_position)
	if (len(path)>0):
		nextRoutePoint = path[0]
	state = 7
	
	daughterSaidInvestigateLaptop = true
	
func investigate_will_after_daughter_request():
	say("i_will_go_investigate_the_will")
	print("going to investigate laptop")
	timerUntilDoneInvestigating = null #clear investigation timer (if the investigator was investigating they should immeditely go to this new position)
	path = navigation.get_ideal_path(self.global_position, self.get_node("../Clues/InsurranceWillDocument").global_position)
	if (len(path)>0):
		nextRoutePoint = path[0]
	state = 9
	daughterSaidInvestigateWill = true
	
func ask_son_about_laptop():
	print("going to investigate laptop")
	timerUntilDoneInvestigating = null #clear investigation timer (if the investigator was investigating they should immeditely go to this new position)
	path = navigation.get_ideal_path(self.global_position, son.global_position)
	if (len(path)>0):
		nextRoutePoint = path[0]
	state = 11
func investigate_laptop_again_son():
	print("investigating laptop again at son's request")
	timerUntilDoneInvestigating = null #clear investigation timer (if the investigator was investigating they should immeditely go to this new position)
	path = navigation.get_ideal_path(self.global_position, self.get_node("../Clues/ComputerWithPlantedSearchHistory").global_position)
	if (len(path)>0):
		nextRoutePoint = path[0]
		
	sonSaidInvestigateLaptopAgain = true
	
	var temp = []
	for element in alreadyVisited: #remove the laptop from already visited, so that it gets visited again
		if element[1] != 4:
			temp.append(element)
	alreadyVisited=temp
	
	state = 13
func investigate_sound(position: Vector2):
	say("i_will_go_investigate")
	print("going to investigate sound")
	timerUntilDoneInvestigating = null #clear investigation timer (if the investigator was investigating they should immeditely go to this new position)
	path = navigation.get_ideal_path(self.global_position, position)
	print("pathToSound:")
	print(path)
	if (len(path)>0):
		nextRoutePoint = path[0]
	state = 3
	
func daughter_confessed():
	say("solved_murder_journal_last")
	playerWins()
func _on_main_ready() -> void:
	path = navigation.get_ideal_path(self.global_position, destination)

#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		say("daughter_guilty_and_tried_framing_son")
