extends CharacterBody3D

const SPEED = 300.0
const ASCENT_SPEED = 50.0
const STOP_SPEED = 10.0
const TURN_SPEED = 1.0

@onready var player = $Player

func _physics_process(delta):
	if Input.is_action_pressed("sub_left"):
		rotate_object_local(Vector3(0.0, 1.0, 0.0), -TURN_SPEED * delta)
	if Input.is_action_pressed("sub_right"):
		rotate_object_local(Vector3(0.0, 1.0, 0.0), TURN_SPEED * delta)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("sub_down", "sub_up", "sub_forward", "sub_back")
	var direction = (global_transform.basis * Vector3(0.0, input_dir.x, input_dir.y)).normalized()
	if direction:
		velocity.z = direction.z * SPEED * delta
		velocity.y = direction.y * ASCENT_SPEED * delta
	else:
		velocity.y = move_toward(velocity.y, 0, STOP_SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, STOP_SPEED * delta)
		
	move_and_slide()
