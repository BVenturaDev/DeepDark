extends CharacterBody3D

const SPEED = 2.0
const STOP_SPEED = 2.0
const TURN_SPEED = 10.0

@onready var player = $Player

func _init():
	pass
	"""
	velocity.x = randf_range(-5.0, 5.0)
	velocity.y = randf_range(-5.0, 5.0)
	velocity.z = randf_range(-5.0, 5.0)
	print(velocity)
	"""

func _physics_process(delta):
	var direction = global_transform.basis.get_euler() * Vector3.FORWARD
	if Input.is_action_pressed("sub_forward"):
		direction.z -= 1
	if Input.is_action_pressed("sub_back"):
		direction.z += 1
	if Input.is_action_pressed("sub_down"):
		direction.y -= 1
	if Input.is_action_pressed("sub_up"):
		direction.y += 1
	if Input.is_action_pressed("sub_left"):
		rotation_degrees.y -= TURN_SPEED * delta
	if Input.is_action_pressed("sub_right"):
		rotation_degrees.y += TURN_SPEED * delta
	direction = direction.normalized()
	velocity += direction * SPEED * delta
	velocity.x = clampf(velocity.x, -3.0, 3.0)
	velocity.y = clampf(velocity.y, -3.0, 3.0)
	velocity.z = clampf(velocity.z, -3.0, 3.0)
	
	velocity.x = move_toward(velocity.x, 0, SPEED / STOP_SPEED * delta)
	velocity.y = move_toward(velocity.y, 0, SPEED / STOP_SPEED * delta)
	velocity.z = move_toward(velocity.z, 0, SPEED / STOP_SPEED * delta)
	move_and_slide()
