extends CharacterBody3D

const SPEED = 30.0
const ACCELERATION = 10.0
const JUMP_VELOCITY = 4.5
const FRICTION = 15.0  # Friction factor, adjust this to change the rate of deceleration

const MIN_FOV = 70.0  # Minimum field of view
const MAX_FOV = 90.0  # Maximum field of view
const FOV_CHANGE_RATE = 5.0  # Rate of change for the FOV

@onready var camera = $"Camera Controller/Camera Target/SpringArm3D/Camera3D"

@onready var cameraController = $"Camera Controller"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#func _unhandled_input(event):
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		var n = ($FrontLeft.get_collision_normal() + $FrontRight.get_collision_normal() + $RearLeft.get_collision_normal() + $RearRight.get_collision_normal() + $FrontCentre.get_collision_normal() + $RearCentre.get_collision_normal() + $Centre.get_collision_normal()) / 7.0
		var xform = align_with_y(global_transform, n)
		global_transform = global_transform.interpolate_with(xform, 12 * delta)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/acceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.z = move_toward(velocity.z, 0, FRICTION * delta)
	
	set_floor_max_angle(30.0)
	set_floor_snap_length(4.0)
	move_and_slide()

	# Adjust the camera FOV based on the player's speed
	adjust_camera_fov(delta)

	# Check if the player is tilted along the X-axis (tipping forward or backward)
	var tilt_degree = get_tilt_degree()
	if tilt_degree > 1:  # Adjust the threshold as needed
		tilt_camera(-tilt_degree - 15, delta)
	elif tilt_degree < -1:  # Adjust the threshold as needed
		reset_camera(delta)
	else:
		reset_camera(delta)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func get_tilt_degree() -> float:
	# Get the forward vector and the up vector
	var forward_vector = transform.basis.z
	var up_vector = transform.basis.y

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
	cameraController.rotation.x = lerp(cameraController.rotation.x, target_rotation, 5.0 * delta)  # Increased lerp factor

func reset_camera(delta: float):
	# Reset the camera tilt smoothly
	cameraController.rotation.x = lerp(cameraController.rotation.x, 0.0, 5.0 * delta)  # Increased lerp factor

func adjust_camera_fov(delta: float):
	# Calculate the player's speed in the horizontal plane
	var horizontal_speed = sqrt(velocity.x * velocity.x + velocity.z * velocity.z)
	# Map the speed to the FOV range
	var target_fov = lerp(MIN_FOV, MAX_FOV, horizontal_speed / SPEED)
	# Smoothly interpolate the camera's FOV
	camera.fov = lerp(camera.fov, target_fov, FOV_CHANGE_RATE * delta)
