extends CharacterBody3D


const SPEED = 2.0
var mouse_sens = 0.002

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Input Mode Captured
var mouse_mode = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):  		
	if event is InputEventMouseMotion && mouse_mode:
		rotation.y -= event.relative.x * mouse_sens
		$Camera3D.rotation.x -= event.relative.y * mouse_sens
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-60.0), deg_to_rad(60.0))
		$Camera3D.rotation.z = 0.0
	elif event.is_action_pressed("ui_escape"):
		if mouse_mode:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_mode = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_mode = true
