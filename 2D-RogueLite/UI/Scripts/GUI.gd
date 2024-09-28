extends CanvasLayer

# ------------------------------- Variables ---------------------------------

const HEART_ROW_SIZE = 8
const HEART_OFFSET = 16

@onready var timer = $"../Timer"
# ------------------------------- Functions ---------------------------------

# Ready Function ---------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in player_data.health:
		var new_heart = Sprite2D.new()		# Creating new heart sprites
		# Copies heart sprite and hframe, then adds new heart as child of original heart
		new_heart.texture = $heart_sprite.texture
		new_heart.hframes = $heart_sprite.hframes
		$heart_sprite.add_child(new_heart)

# Process Function --------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Display ammo count from player data and timer countdown
	$ammo_amount_label.text = var_to_str(player_data.ammo)
	$timer_countdown.text = var_to_str(timer.time_left).pad_decimals(0)	# displays timer and counts down with no decimal points
	
	# For loop to display corect amount of hearts for player health
	for heart in $heart_sprite.get_children():
		var index = heart.get_index()	# get index of child node, uses row size and offset to align additional hearts nicely
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = (index / HEART_ROW_SIZE) * HEART_OFFSET
		heart.position = Vector2(x, y)
		
		# If statements to control red and black hearts being displayed
		var last_heart = floor(player_data.health)
		if index > last_heart:
			heart.frame = 0
		if index == last_heart:
			heart.frame = (player_data.health - last_heart) * 4
		if index < last_heart:
			heart.frame = 4
