extends CharacterBody3D

@onready var InteractCast = $Camera3D/RayCast3D
@onready var col = $CollisionShape3D
@onready var water = $Water
@onready var anim = $Water/AnimationPlayer
@onready var lose_label = $Water/LoseLabel
@onready var light = $Camera3D/SpotLight3D
@onready var click_sfx = $ClickStreamPlayer

const SPEED = 150.0
const STOP_SPEED = 50.0
var mouse_sens = 0.002
var mouse_drag_coords = Vector2()
var mouse_clicked = false
var interacting = false
var last_target

var dead = false

var no_clip = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Input Mode Captured
var mouse_mode = true

var is_under_water = false

func under_water():
	if is_under_water:
		water.visible = true
		if not anim.is_playing():
			anim.play("die")
	else:
		water.visible = false
		if anim.is_playing():
			anim.stop()

func _ready():
	SystemGlobal.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	if not dead:
		under_water()
		
		# Check for Interaction
		if InteractCast.is_colliding() and InteractCast.get_collider() and not interacting:
			var target = InteractCast.get_collider()
			if target.is_in_group("interactable"):
				if not target.targeted:
					# Valid Target
					interacting = true
					target.change_targeted(true)
					last_target = target
		else:
			# No Valid target
			if last_target:
				last_target.change_targeted(false)
			interacting = false
		
		# Add the gravity.
		if not is_on_floor() and not no_clip:
			velocity.y -= gravity * delta
		elif Input.is_action_pressed("flight_mode_up") and SystemGlobal.DEBUG_MODE and no_clip:
			velocity.y = SPEED * delta
		elif Input.is_action_pressed("flight_mode_down") and SystemGlobal.DEBUG_MODE and no_clip:
			velocity.y = -SPEED * delta
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED * delta
			velocity.z = direction.z * SPEED * delta
		else:
			velocity.x = move_toward(velocity.x, 0, STOP_SPEED * delta)
			velocity.z = move_toward(velocity.z, 0, STOP_SPEED * delta)
			if no_clip:
				velocity.y = move_toward(velocity.y, 0, STOP_SPEED * delta)

		move_and_slide()

func _input(event):
	if not dead:
		# Handle Click
		if Input.is_action_just_pressed("click"):
			mouse_clicked = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
			mouse_drag_coords = get_viewport().get_mouse_position()
			if last_target and last_target.has_method("hold_button"):
				last_target.hold_button()
		elif Input.is_action_just_released("click"):
			click_sfx.play()
			mouse_clicked = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			if last_target and last_target.has_method("tilt_controller"):
				last_target.tilt_controller(Vector2())
			elif last_target and last_target.has_method("press_button"):
				last_target.press_button()
			if last_target and last_target.has_method("release_button"):
				last_target.release_button()
		# Handle Mouse Move
		if event is InputEventMouseMotion and mouse_mode and not mouse_clicked:
			rotation.y -= event.relative.x * mouse_sens
			$Camera3D.rotation.x -= event.relative.y * mouse_sens
			$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-60.0), deg_to_rad(60.0))
			$Camera3D.rotation.z = 0.0
		# Mouse is moving a controller
		elif event is InputEventMouseMotion and mouse_clicked and interacting:
			if last_target and last_target.has_method("tilt_controller"):
				var tilt = Vector2()
				var mouse_pos = get_viewport().get_mouse_position()
				tilt.y = (mouse_drag_coords.y - mouse_pos.y) / mouse_drag_coords.y
				tilt.x = (mouse_drag_coords.x - mouse_pos.x) / -mouse_drag_coords.x
				tilt.x = clampf(tilt.x, -1.0, 1.0)
				tilt.y = clampf(tilt.y, -1.0, 1.0)
				last_target.tilt_controller(tilt)
		
		# Escape Key Changes Mouse Mode
		if event.is_action_pressed("no_clip") and SystemGlobal.DEBUG_MODE:
			if no_clip:
				print("No Clip Off")
				no_clip = false
				col.disabled = false
			else:
				print("No Clip On")
				no_clip = true
				col.disabled = true
		
		if event.is_action_pressed("find_eel") and SystemGlobal.DEBUG_MODE and no_clip:
			if SystemGlobal.eels:
				global_position = SystemGlobal.eels[0].global_position
		
		if event.is_action_pressed("no_clip_light") and SystemGlobal.DEBUG_MODE and no_clip:
			light.visible = !light.visible
		# Escape Key Changes Mouse Mode
		if event.is_action_pressed("ui_escape"):
			if mouse_mode:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				mouse_mode = false
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				mouse_mode = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "die":
		dead = true
		lose_label.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_mode = false
		print("GAME OVER")
		anim.play("dead")
