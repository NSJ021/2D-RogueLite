extends Node2D


# ------------------------------- Variables ---------------------------------

@onready var player_scene = preload("res://Entities/Scenes/Player/player.tscn")
@onready var exit_scene = preload("res://Interactables/Scenes/exit.tscn")
@onready var enemy_scene = preload("res://Entities/Scenes/Enemy/enemy_1.tscn")
@onready var tilemap = $TileMap
@export var borders = Rect2(1, 1, 90, 60)	# 85 , 42 used to define where the rooms can be creating on screen, adjust based on tilemap
var walker
var map

var ground_layer = 0

# ------------------------------- Functions ---------------------------------

# Ready Function ---------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_level()

# Generate Level Function ---------------
# Logic for generating the procedural levels
func generate_level():
	walker = Walker_room.new(Vector2(3,5), borders)		# Assigns walker form Walker_room script
	map = walker.walk(500)	# calls  walk function via walker, with 300 steps
	
	# Creating arrays for storing cells used for the level
	var using_cells : Array = []
	var all_cells : Array = tilemap.get_used_cells(ground_layer)
	
	# Clear the tile map and delete the walker
	tilemap.clear()
	walker.queue_free()
	
	# loop to iterate through tile in all cells array, if there is no map then add tiles to the using cells array
	for tile in all_cells:
		if !map.has(Vector2(tile.x, tile.y)):
			using_cells.append(tile)
	
	# uipdate tilemap, layer int, Array, Terrain Set, Terrain, ignore empty terrains T or F
	tilemap.set_cells_terrain_connect(ground_layer, using_cells, ground_layer, ground_layer, false)
	tilemap.set_cells_terrain_path(ground_layer, using_cells, ground_layer, ground_layer, false)
	
	# Spawns player
	instance_player()
	# Spawns Exit
	instance_exit()
	# Spawns Enemies
	instance_enemy()

# Input Function ------------ 
func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

# Instancing Functions ---------------------------------------

# Instance Player Function -------------------
# Function for spawning the player in the level
func instance_player():
	# Assigns player scene and adds as child to root
	var player = player_scene.instantiate()
	add_child(player)
	
	# Gets map location and room details from array in walker
	player.position = map.pop_front() * 16

# Instance Exit Function ------------------
# Logic for spawning the exit location
func instance_exit():
	# Assigns exit scene and adds child to root
	var exit = exit_scene.instantiate()
	add_child(exit)
	# Uses Get end room function from walker
	exit.position = walker.get_end_room().position * 16

# Instance Enemy Function --------------------
# Logic for spawning enemies in the level
func instance_enemy():
	for i in range(10):	# Iterates 12 times, amount of enemies to spawn
		var enemy = enemy_scene.instantiate()	# Instanciates Enemy
		enemy.position = (map.pick_random() * borders.position) * 16	# Places enemy at a random position on Tilemap but with borders
		add_child(enemy)	# Adds enemy as child of the main scene

# Timer Timeout Function --------------
# Logic for what happens when the level timer runs out
func _on_timer_timeout():
	get_tree().reload_current_scene()
