extends Area2D


# ------------------------------- Variables ---------------------------------

@onready var fx_scene = preload("res://Entities/Scenes/FX/fx_scene.tscn")
@export var speed : int = 50

var direction =  Vector2.RIGHT


# ------------------------------- Functions ---------------------------------

# Ready Function --------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Process Function ----------------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(direction * speed * delta)	# Translate applies force to the bullet, default is to the right * speed * delta

# Body Entered Function -----------------------
# Handles logic for when the bullet hits colides with something
func _on_body_entered(_body):
	instance_fx_explosion()	#	calls explosion FX
	Globals.camera.screen_shake(5, 5, 0.05)	# Calls screen shake function
	queue_free() # Deletes bullet from scene

# Visible Screen Exit Function -----------------
# Handles the logic for deleting the bullets as they go off the screen
func _on_visible_screen_exited():
	queue_free()

# Instance FX Explosion Function -------------
# Logic for creating the explosion effect
func instance_fx_explosion():
	var fx_explosion = fx_scene.instantiate()
	fx_explosion.global_position = global_position
	get_tree().root.add_child(fx_explosion)
