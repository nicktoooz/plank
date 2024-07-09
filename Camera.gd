extends Node3D

@onready var player = $".."

# Called when the node enters the scene tree for the first time.
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * 0.1))
		player.rotate_y(deg_to_rad(-event.relative.x * 0.1))

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Lerp position
	position = lerp(position, player.position, 0.1)
	# Lerp rotation
	var target_rotation = player.rotation.y
	var current_rotation = rotation.y
	rotation.y = lerp_angle(current_rotation, target_rotation, 0.2)
