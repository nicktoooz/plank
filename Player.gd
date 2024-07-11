extends CharacterBody3D

@onready var btnJump = $"../JumpButton"
@onready var area3d = $Area3D
const SPEED = 30.0
const ACCELERATION = 10.0
const JUMP_VELOCITY = 4.5
const FRICTION = 30.0  

var is_colliding = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	area3d.body_entered.connect(_on_area_entered)
	area3d.body_exited.connect(_on_area_exited)
	

func _physics_process(delta):
	
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		var n = ($FrontLeft.get_collision_normal() + $FrontRight.get_collision_normal() + $RearLeft.get_collision_normal() + $RearRight.get_collision_normal() + $FrontCentre.get_collision_normal() + $RearCentre.get_collision_normal() + $Centre.get_collision_normal()) / 7.0
		var xform = align_with_y(global_transform, n)
		global_transform = global_transform.interpolate_with(xform, 12 * delta)

	if (Input.is_action_just_pressed("ui_accept") or btnJump.is_pressed()) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.z = move_toward(velocity.z, 0, FRICTION * delta)
	
	
	floor_snap_length = 4.0
	move_and_slide()
	

func _body_entered():
	pass
	

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func _on_area_entered(body):
	is_colliding =  true
	velocity.x = 0
	velocity.z = 0
	
	print('colliding')

func _on_area_exited(body):
	is_colliding =  false
	print('not colliding')

	
