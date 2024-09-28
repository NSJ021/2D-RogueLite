extends CharacterBody2D



# ------------------------------- Variables ---------------------------------
@onready var fx_scene = preload("res://Entities/Scenes/FX/fx_scene.tscn")
@onready var ammo_scene = preload("res://Interactables/Scenes/ammo_1.tscn")
@export var speed : int = 20

enum enemy_direction {RIGHT, LEFT, UP, DOWN, CHASE}
var new_direction = enemy_direction.RIGHT
var change_direction

@onready var target = get_node("../Player")

# ------------------------------- Functions ---------------------------------

# Ready Function ---------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	choose_direction()

# Process Function -------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Match statement ro handles player movement
	match new_direction:
		enemy_direction.RIGHT:
			move_right()
			
		enemy_direction.LEFT:
			move_left()
			
		enemy_direction.UP:
			move_up()
			
		enemy_direction.DOWN:
			move_down()
			
		enemy_direction.CHASE:
			chase_state()


# Movement Fucntions ---------------------------------
# Move right Function -----------------
func move_right():
	velocity = Vector2.RIGHT * speed
	$anim.play("move-right")
	move_and_slide()

# Move right Function -----------------
func move_left():
	velocity = Vector2.LEFT * speed
	$anim.play("move-left")
	move_and_slide()

# Move right Function -----------------
func move_up():
	velocity = Vector2.UP * speed
	$anim.play("move-up")
	move_and_slide()

# Move right Function -----------------
func move_down():
	velocity = Vector2.DOWN * speed
	$anim.play("move-down")
	move_and_slide()

# Choose direction Function -------------
# Logic for choosing the next direction of the enemy
func choose_direction():
	change_direction = randi() % 4	#	used randI to ick a number between 0 and 3
	random_direction()

# Random Direction Function --------------
# Logic for randomising the direction of the enemy
func random_direction():
	
	# Match statement to select a direction,linked to randI from choose direction
	match change_direction:
		0:
			new_direction = enemy_direction.RIGHT
		1:
			new_direction = enemy_direction.LEFT
		2:
			new_direction = enemy_direction.UP
		3:
			new_direction = enemy_direction.DOWN


# Timer Timeout Function ----------------
# Logic for controling the wait timer of the enemy to create random moves
func _on_timer_timeout():
	choose_direction()
	$Timer.start()

# Entering Hitbox Area Function --------------
# Handles the logic for anything hitting the enemy, e.g. Bullets
func _on_hitbox_area_entered(area):
	if area.is_in_group("Bullet"):	# checks if object entered if a bullet or not
		instance_fx_explosion()	# call fx explosion
		instance_ammo()	 # Call ammo spawn
		queue_free()	# Deletes the enemy

# Instance FX Explosion Function -------------
# Logic for creating the explosion effect
func instance_fx_explosion():
	var fx_explosion = fx_scene.instantiate()
	fx_explosion.global_position = global_position
	get_tree().root.add_child(fx_explosion)

# Instance Ammo Function -------------
# Logic for creating the spawning ammo
func instance_ammo():
	call_deferred("_instance_ammo")

func _instance_ammo():
	var ammo = ammo_scene.instantiate()
	ammo.global_position =  global_position
	get_tree().root.add_child(ammo)


# Chase State Function ----------------
# Logic for when the enemy can chase the player via scent trail
func chase_state():
	var chase_speed : int = 60
	velocity = position.direction_to(target.global_position) * chase_speed	# Changes velocity to target the player
	animation()
	move_and_slide()

# Animation Function --------------- 
# Contains logic for animatons of the enemy, animation correction for chase mode
func animation():
	if velocity > Vector2.ZERO:
		$anim.play("move-right")
	if velocity < Vector2.ZERO:
		$anim.play("move-left")


# Chase Box Area Entered Function -------------
# Handles the logic for when the enemy detects the players scent and begins to chase
func _on_chase_box_area_entered(area):
	if area.is_in_group("Follow"):
		new_direction = enemy_direction.CHASE
