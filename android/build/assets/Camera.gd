extends Node3D

@onready var player = $".."

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * 0.1))
		player.rotate_y(deg_to_rad(-event.relative.x * 0.1))
		

func _ready():
	pass 

func _process(delta):
	position = lerp(position, player.position, 0.50)
	var target_rotation_y = player.rotation.y
	var current_rotation_y = rotation.y
	rotation.y = lerp_angle(current_rotation_y, target_rotation_y, 0.2)