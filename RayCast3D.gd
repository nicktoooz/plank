extends RayCast3D

var max_distance = 10.0
@onready var camera_controller = $"../../../.."

func _ready():
	# Set the initial length of the raycast
	max_distance = target_position.length()

func _process(delta):
	if is_colliding():
		var collision_point = get_collision_point()
		var origin = global_transform.origin
		var collision_distance = origin.distance_to(collision_point)
		var collision_intensity = max_distance - collision_distance
		
		# Adjust camera height based on collision intensity
		var height_adjustment = collision_intensity * 0.1 # Adjust the multiplier as needed
		camera_controller.global_transform.origin.y += height_adjustment * delta # Ensure smooth adjustment
		
		print("Collision intensity: ", collision_intensity)
	else:
		print("No collision")
