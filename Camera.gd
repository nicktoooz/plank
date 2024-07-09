extends Node3D

@onready var player = $".."

# Called when the node enters the scene tree for the first time.
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * 0.1))
		player.rotate_y(deg_to_rad(-event.relative.x * 0.1))
		# Adjust camera rotation based on mouse motion

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Lerp position
	position = lerp(position, player.position, 0.2)
	# Lerp rotation for the y-axis
	var target_rotation_y = player.rotation.y
	var current_rotation_y = rotation.y
	
	rotation.y = lerp_angle(current_rotation_y, target_rotation_y, 0.2)
