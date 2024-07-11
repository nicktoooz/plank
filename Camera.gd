extends Node3D

@onready var player = $".."
@onready var camera = $"Camera Target/SpringArm3D/Camera3D"
var target_rotation: float = 0.0

const MIN_FOV = 70.0  # Minimum field of view
const MAX_FOV = 90.0  # Maximum field of view
const FOV_CHANGE_RATE = 5.0  # Rate of change for the FOV

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var rotation_amount = deg_to_rad(-event.relative.x * 0.1)
		target_rotation += rotation_amount

func _ready():
	pass 

func _process(delta):
	
	# Interpolate position
	position = lerp(position, player.position, 0.25)
	
	# Interpolate rotation
	var current_rotation = player.rotation.y
	var new_rotation = lerp_angle(current_rotation, target_rotation, 0.1)
	player.rotation.y = new_rotation
	rotation.y = new_rotation
	
	
	# Adjust the camera FOV based on the player's speed
	adjust_camera_fov(delta)
	
	var tilt_degree = get_tilt_degree()
	if tilt_degree > 1:  # Adjust the threshold as needed
		tilt_camera(-tilt_degree - 8, delta)
	elif tilt_degree < -1:  # Adjust the threshold as needed
		tilt_camera(tilt_degree, delta)
		reset_camera(delta)
		pass
	else:
		reset_camera(delta)
		pass


func get_tilt_degree() -> float:
	# Get the forward vector and the up vector
	var forward_vector = player.transform.basis.z
	var up_vector = player.transform.basis.y

	# Calculate the angle between the forward vector and the horizontal plane
	var horizontal_forward = Vector3(forward_vector.x, 0, forward_vector.z).normalized()
	var tilt_radians = forward_vector.angle_to(horizontal_forward)

	# Use the dot product to determine the direction of the tilt
	if forward_vector.y < 0:
		tilt_radians = -tilt_radians

	# Convert the angle to degrees
	var tilt_degrees = rad_to_deg(tilt_radians)
	return tilt_degrees

func tilt_camera(tilt_degree: float, delta: float):
	# Tilt the camera smoothly based on the player's tilt degree
	var target_rotation = deg_to_rad(tilt_degree)
	rotation.x = lerp(rotation.x, target_rotation, 1.0 * delta)  # Increased lerp factor

func reset_camera(delta: float):
	# Reset the camera tilt smoothly
	rotation.x = lerp(rotation.x, 0.0, 1.0 * delta)  # Increased lerp factor

func adjust_camera_fov(delta: float):
	# Calculate the player's speed in the horizontal plane
	var horizontal_speed = sqrt(player.velocity.x * player.velocity.x + player.velocity.z * player.velocity.z)
	# Map the speed to the FOV range
	var target_fov = lerp(MIN_FOV, MAX_FOV, horizontal_speed / player.SPEED)
	# Smoothly interpolate the camera's FOV
	camera.fov = lerp(camera.fov, target_fov, FOV_CHANGE_RATE * delta)
