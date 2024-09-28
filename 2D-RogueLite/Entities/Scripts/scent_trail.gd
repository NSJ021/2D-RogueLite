extends Area2D

# ------------------------------- Variables ---------------------------------



# ------------------------------- Functions ---------------------------------

# Remove Trail function ----------
# Logic to remove the scent trail
func remove_trail():
	queue_free()

# Timer Timeout Function
func _on_timer_timeout():
	remove_trail()	#	Call remove trail function to r periodically remove the trail of the player
