extends CharacterBody2D

# ------------------------------- Variables ---------------------------------

# State Machine -----------------
var current_state = player_state.MOVE
enum player_state {MOVE, DEAD}
var is_dead : bool = false

# PLayer Variables ---------
@export var speed : int = 75
var input_movement = Vector2()

# Gun Variables ------
@onready var gun = $gun_handler
@onready var gun_sprite = $gun_handler/gun_sprite
@onready var bullet_point = $gun_handler/bullet_point

# Mouse Targeting Varibales ---------
var pos
var rot

# Bullet Variables --------
@onready var bullet_scene = preload("res://Entities/Scenes/Bullet/bullet_1.tscn")

# Scent Trail Variables ----------
@onready var scent_trail_scene = preload("res://Entities/Scenes/FX/scent_trail.tscn")

# ------------------------------- Functions ---------------------------------

# Ready Function --------------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Process Function ------------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Checks player health to decide fi dead or not
	if player_data.health <= 0:
		current_state =  player_state.DEAD
	
	# Calls target mouse function
	target_mouse()
	# calls joystick controller
	joystick_mouse_controller(delta)
	
	# Match statement for deciding if player is moving or dead
	match current_state:
		player_state.MOVE:
			movement(delta)
		player_state.DEAD:
			dead()

# Movement Function --------------------------
# Handles all movement operations of the player, WASD, Left Right Up Down.
func movement(_delta):

	# Calls animation function
	animations()
	input_movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Checks if vector2 is not 0, then multiples movement by speed
	if input_movement != Vector2.ZERO:
		velocity = input_movement * speed

	# Checks if vector2 is 0, then stops any movement
	if input_movement == Vector2.ZERO:
		velocity = Vector2.ZERO
	
	# Checks if player is trying to shoot and if ammo is available, subtracts each bullet shot then instances a bullet
	if Input.is_action_just_pressed("ui_shoot") && player_data.ammo > 0: 
		player_data.ammo -= 1	# controls ammo usage
		instance_bullet()
	
	# Calls move and slide function to enable movement
	move_and_slide()

# Animation Function -----------------------------
# Handles all player animations
func animations():
		# Checks if vector2 is not 0, then mplays movement animaton
	if input_movement != Vector2.ZERO:
		
		# conditionals to check if the player is moving left or right and flips the sprite
		
		# X movement ----
		if input_movement.x > 0:
			$anim.play("Move")

		if input_movement.x < 0:
			$anim.play("Move")

		# Y Movement -----
		if input_movement.y > 0:
			$anim.play("Move")

		if input_movement.y < 0:
			$anim.play("Move")


	# Checks if vector2 is 0, then plays idle animation
	if input_movement == Vector2.ZERO:
		$anim.play("Idle")

# Dead Function -----------------
# Handles the logic for when the player dies
func dead():
	is_dead = true
	velocity = Vector2.ZERO		#Sets velocity to 0 to stop movement
	gun.visible = false		# Toggles gun visibility
	$anim.play("Dead")		# PLays dead animation


# Target Mouse Function -------------------------
# handles the logic for making the gun follow the mouse pointer
func target_mouse():
	if is_dead == false:
		var mouse_movement = get_global_mouse_position()	# Gets mouse position
		pos = global_position		# gets global player positon as pos
		gun.look_at(mouse_movement)		# tells the gun handlers to look at mouse position
		rot = rad_to_deg((mouse_movement - pos).angle())	# changes radians to degrees, using mouse position and pos and returns a vector2
		
		# conditional statement to flip the gun and player correctly based on mouse position
		if rot >= -90 and rot <= 90:
			gun_sprite.flip_v = false
			$player_sprite.flip_h = false
		else:
			gun_sprite.flip_v = true
			$player_sprite.flip_h = true
	else:
		return

# Joystick Mouse COntroller Function --------------
# Logic for enabling the use of a joystick to control the mouse aiming
func joystick_mouse_controller(delta):
	
	if is_dead == false:
		var mouse_sense = 1000.0
		var direction : Vector2
		var movement : Vector2
		
		direction.x = Input.get_action_strength("rs_right") - Input.get_action_strength("rs_left")
		direction.y = Input.get_action_strength("rs_down") - Input.get_action_strength("rs_up")
		
		if abs(direction.x) == 1 and abs(direction.y) == 1:
			direction = direction.normalized()
		movement =  mouse_sense * direction * delta
		
		if (movement):
			get_viewport().warp_mouse(get_viewport().get_mouse_position() + movement)
	if is_dead == true:
		return

# Instance Bullet Function ------------------------
# Handles all logic for creating a bullet when the player shoots
func instance_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.direction = bullet_point.global_position - global_position 	# calculates position of player and end of gun and defines direction of bullet
	bullet.global_position = bullet_point.global_position	# Sets bullets spawn point to end of gun
	get_tree().root.add_child(bullet)  # Finds node tree, adds bullet as a child so it acts independant of the player

# Reset State Function
# Handles the resetting of players states
func reset_state():
	current_state = player_state.MOVE


# Instance Trail Function ------------
# Logic for creating the scent trail of the player
func instance_trail():
	var trail = scent_trail_scene.instantiate()
	trail.global_position = global_position
	get_tree().root.add_child(trail)

# Trail Timer Fuction
# logic for the trail timer of the player
func _on_trail_timer_timeout():
	instance_trail()
	$trail_timer.start()

# Hitbox entered function -----------------
# Logic for handling when the player and enemy hit each other
func _on_hitbox_area_entered(area):
	if area.is_in_group("Enemy"):
		flash()
		player_data.health -= 1

# Flash Function --------------
# Contains logic for applying a flashing shader on the player
func flash():
	$player_sprite.material.set_shader_parameter("flash_modifier", 1)	# sets flash to ON 100%
	await get_tree().create_timer(0.3).timeout	#	waits for 0.3 on a time, edit this for length of flash
	$player_sprite.material.set_shader_parameter("flash_modifier", 0)	# Sets Flash to ON 0%

# On Animation Finish Function ------------
# Logic to handle the ending of the death animation to create a smoother transition on death
func _on_anim_animation_finished(anim_name):
	if anim_name == "Dead":
		get_tree().reload_current_scene()	# reloads current level after timeout
		player_data.health += 4
