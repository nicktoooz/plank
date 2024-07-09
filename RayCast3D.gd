extends RayCast3D

var max_distance = 10.0
@onready var camera_controller = $"../../../.."
var original_height = 0.0

func _ready():
	# Set the initial length of the raycast
	max_distance = target_position.length()
	original_height = camera_controller.global_transform.origin.y

func _process(delta):
	if is_colliding():
		var collision_point = get_collision_point()
		var origin = global_transform.origin
		var collision_distance = origin.distance_to(collision_point)
		var collision_intensity = max_distance - collision_distance
		
		# Adjust camera height based on collision intensity
		var target_height = original_height + collision_intensity * 20.0 # Adjust the multiplier as needed
		camera_controller.global_transform.origin.y = lerp(camera_controller.global_transform.origin.y, target_height, 0.1) # Ensure smooth adjustment

		print("Collision intensity: ", collision_intensity)
	else:
		print("No collisiond")
		# Reset camera height smoothly
		camera_controller.global_transform.origin.y = lerp(camera_controller.global_transform.origin.y, original_height, 5.0 * delta)
