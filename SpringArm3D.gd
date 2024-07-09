extends SpringArm3D

var max_length = 0

func _ready():
	# Store the initial length of the spring arm as the maximum length
	max_length = spring_length

func _process(delta):
	# Check if the spring arm has collided
	if spring_length < max_length:
		var collision_intensity = max_length - spring_length
		print("Collision intensity: ", collision_intensity)
	else:
		print("No collision")
