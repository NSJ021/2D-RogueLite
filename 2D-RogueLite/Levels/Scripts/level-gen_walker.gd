extends Node

class_name  Walker_room


# ------------------------------- Variables ---------------------------------

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []

var steps_since_turn = 0
var rooms = []


# ------------------------------- Functions ---------------------------------

# Init Function --------------------------
# Function for initialising the level generrtion process
func _init(starting_position, new_borders):
	assert(new_borders.has_point(starting_position))	# Making sure our starting point is witihn our game borders
	position = starting_position
	step_history.append(position)	# add chosen position to list
	borders = new_borders

# Walk function --------------------------
# Function that returns a list of Vectors 
func walk(steps):
	
	place_room(position)
	
	# Loops through steps, changes directon based on amount of steps taken, each step taken is added to step history
	for step in steps:
		if steps_since_turn >= 7.5:
			change_directon()
		
		if step():
			step_history.append(position)
		else:
			change_directon()
	return step_history

# Step Function ----------------------------
# Handles logic for chosing which steps in the generation of the levels
func step():
	var target_position = position + direction
	# if statement to check if a step can be taken within the game borders
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false


# Change Direction Function -----------------------
# Handles the logic for changing the direction of the steps as the level is generated
func change_directon():
	
	place_room(position)
	
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	
	directions.erase(direction)	# Erases direction from the list to stop too many repetions
	directions.shuffle()	# Shuffles the directions list
	
	direction = directions.pop_front()	# Takes an element from the list and removes it
	
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

# Create Room Function ----------------------------
# Function for creating rooms in the levels, simply returns a position and size
func create_room(position, size):
	return {position = position, size = size}

# Place Room Function -----------------------------
# Logic for placing a room in the level, starts by creating a size by random integers and setting a top left corner
func place_room(position):
	var size = Vector2(randi() % 4 + 2, randi() % 4 + 2)
	var top_left_corner =  (position - size / 2).floor()
	
	# Adds created room sizes to rooms list
	rooms.append(create_room(position, size))
	
	# Double loop to loop through a grid, with borders
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x,y)
			if borders.has_point(new_step):
				step_history.append(new_step)

# Get End Room Function ----------------------------
# Handles logic for getting the end room
func get_end_room():
	var end_room = rooms.pop_back() 	# Pops last element of array
	var starting_position = step_history.front()
	
	# for loop with if statement to check distance between starting position and potential end room
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
	return end_room
