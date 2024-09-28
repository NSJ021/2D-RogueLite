extends Camera2D

# ------------------------------- Functions ---------------------------------

var start_shaking : bool = false
var shake_intensity : float = 0.0
var shake_dampening : float = 0.0

@onready var camera_shake = $camera_shake


# ------------------------------- Functions ---------------------------------

# Ready Function -------------
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.camera = self

# Process Functon -------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# If statement to decide what happens if the camera is shaking, uses randi range to create the shake
	if start_shaking == true:
		offset.x = randi_range(-1,1) * shake_intensity
		offset.y = randi_range(-1,1) * shake_intensity
		shake_intensity = lerp(shake_intensity, 0.0, shake_dampening)
	else:
		offset = Vector2(0,0)

# Screen Shake Function --------------
# Logic for setting up the screen shake
func screen_shake(intensity, duration, dampening):
	shake_intensity = intensity
	camera_shake.wait_time = duration
	shake_dampening = dampening
	start_shaking = true

# On Camera Shake Function -------------
# Logic for what happens when then camera shakes
func _on_camera_shake_timeout():
	start_shaking = false
