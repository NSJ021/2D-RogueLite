extends Node2D


# ------------------------------- Variables ---------------------------------


# ------------------------------- Variables ---------------------------------

# Ready Function ----------------
# Called when the node enters the scene tree for the first time.
func _ready():
	$anim.play("Active")
	await get_tree().create_timer(0.6).timeout

# Process Function ----------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
