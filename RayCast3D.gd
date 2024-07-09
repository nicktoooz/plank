extends RayCast3D

var max_distance = 10.0

func _ready():
	# Set the initial length of the raycast
	max_distance = target_position.length()

func _process(delta):
	# Ensure the RayCast is enabled
	enabled = true

	# Check if the raycast is colliding
	if is_colliding():
		var collision_point = get_collision_point()
		var origin = global_transform.origin
		var collision_distance = origin.distance_to(collision_point)
		var collision_intensity = max_distance - collision_distance
		print("Collision intensity: ", collision_intensity)
	else:
		print("No collision")
