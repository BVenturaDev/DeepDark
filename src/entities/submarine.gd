extends CharacterBody3D

const SPEED = 2.0
const ASCENT_SPEED = 1.5
const STOP_SPEED = 1.0
const TURN_SPEED = 0.5
const MAX_SPEED = 20.0

@onready var player = $Player
@onready var headlights = $Headlights

var input_dir = Vector2()
var ascent_normal = 0.0

func _ready():
	SystemGlobal.sub = self
	SystemGlobal.sonar_casts = $SonarCasts

func _physics_process(delta):
	if SystemGlobal.DEBUG_MODE:
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
	
	if is_on_ceiling():
		velocity.z = -0.1
	
	if is_on_floor():
		velocity.z = 0.1
	
	if input_dir:
		rotate_object_local(Vector3(0.0, 1.0, 0.0), -TURN_SPEED * delta * input_dir.x)
		velocity -= transform.basis.x * SPEED * delta * input_dir.y
	elif ascent_normal != 0.0:
		velocity += transform.basis.y * ASCENT_SPEED * delta * ascent_normal
	else:
		velocity.x = move_toward(velocity.x, 0, STOP_SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, STOP_SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, STOP_SPEED * delta)
		
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = clampf(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.z = clampf(velocity.z, -MAX_SPEED, MAX_SPEED)
	move_and_slide()

func _input(event):
	if event.is_action_pressed("sub_lights") and SystemGlobal.DEBUG_MODE:
		toggle_headlights()

func toggle_headlights():
	headlights.set_visible(!headlights.visible)
