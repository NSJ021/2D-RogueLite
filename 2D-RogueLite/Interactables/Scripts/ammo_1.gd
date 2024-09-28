extends Area2D


# ------------------------------- Variables ---------------------------------

@export var ammo : int = 3


# ------------------------------- Functions ---------------------------------

# Ready Function --------------
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Process Function -------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player":
		player_data.ammo += ammo
		queue_free()

# TImer Timeout Function ------------
# Logic to control what happens at timeout, e.g delete ammo after 3 seconds
func _on_timer_timeout():
	queue_free()
