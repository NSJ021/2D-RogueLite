extends Area2D

# ------------------------------- Variables ---------------------------------


# ------------------------------- Functions ---------------------------------

# Ready Function ------------
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Process Function --------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Changes mouse mode to hidden and gets the mouses position
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	global_position = get_global_mouse_position()
