extends CharacterBody3D

const SPEED = 2.0
const ASCENT_SPEED = 1.5
const STOP_SPEED = 1.0
const TURN_SPEED = 0.5
const MAX_SPEED = 20.0

@onready var player = $Player

func _physics_process(delta):
	if Input.is_action_pressed("sub_left"):
		rotate_object_local(Vector3(0.0, 1.0, 0.0), -TURN_SPEED * delta)
	if Input.is_action_pressed("sub_right"):
		rotate_object_local(Vector3(0.0, 1.0, 0.0), TURN_SPEED * delta)
	
	if Input.is_action_pressed("sub_back"):
		velocity += transform.basis.x * SPEED * delta
	if Input.is_action_pressed("sub_forward"):
		velocity -= transform.basis.x * SPEED * delta
		
	if Input.is_action_pressed("sub_down"):
		velocity -= transform.basis.y * ASCENT_SPEED * delta
	if Input.is_action_pressed("sub_up"):
		velocity += transform.basis.y * ASCENT_SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, STOP_SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, STOP_SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, STOP_SPEED * delta)
		
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = clampf(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.z = clampf(velocity.z, -MAX_SPEED, MAX_SPEED)
	move_and_slide()
