extends CharacterBody3D

const SPEED = 200.0
const TURN_SPEED = 1.0
const MAX_SPEED = 200.0
const SWIM_DISTANCE = 40.0
const ATTACK_SWIM_DISTANCE = 100.0

@onready var anim = $eel_mesh/AnimationPlayer
@onready var nav = $Nav_RayCast3D
@onready var nav_casts = $NavCasts
@onready var timer = $Timer
@onready var nav_timer = $Nav_Timer

var anim_states = ["idle", "swim", "attack"]
var anim_state = 0
var secondary_anim = false

var is_swimming = false
var swim_target = Vector3()
var offset_dir = Vector3()

var is_hunting = true
var just_attacked = false

var is_in_aggro_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", _on_timer_timeout)
	nav_timer.connect("timeout", _on_nav_timer_timeout)

func go_to_random_location(distance):
	var has_target = false
	while not has_target:
		var new_pos = Vector3()
		new_pos.x = randf_range(global_position.x - distance, global_position.x + SWIM_DISTANCE)
		new_pos.y = randf_range(global_position.y - distance, global_position.y + SWIM_DISTANCE)
		new_pos.z = randf_range(global_position.z - distance, global_position.z + SWIM_DISTANCE)
		
		nav.target_position = -(global_position - new_pos)
		nav.force_raycast_update()
		if not nav.is_colliding():
			print(new_pos)
			has_target = true
			swim_to_pos(new_pos)
			break
			
func swim_to_pos(target_pos):
	swim_target = target_pos
	set_anim_state(1)
	is_swimming = true

func set_anim_state(in_state):
	if in_state < anim_states.size() and in_state >= 0:
		anim_state = in_state
		_handle_anim_state()

func _handle_anim_state():
	if anim_state <= 1:
		anim.speed_scale = 1.0
		if not secondary_anim:
			anim.play(anim_states[anim_state])
			secondary_anim = true
		else:
			anim.play(anim_states[anim_state] + "_2")
			secondary_anim = false
	elif anim_state == 2:
		anim.speed_scale = 2.0
		anim.play("attack")

func _has_arrived_at_target():
	if (global_position - swim_target).length() < 4.0:
		is_swimming = false
		if just_attacked:
			just_attacked = false
			SystemGlobal.sub.update_eels()
		if is_hunting:
			_attack()
		else:
			set_anim_state(0)
			timer.start()

func _attack():
	print ("Attack")
	set_anim_state(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not anim.is_playing():
		_handle_anim_state()

	
	if (is_swimming or is_hunting) and swim_target != Vector3():
		var tar_rot = Quaternion(basis.orthonormalized())
		look_at(global_transform.origin + (global_position - swim_target).normalized(), Vector3.UP)
		var rot = Quaternion(basis.orthonormalized())
		rotation = tar_rot.slerp(rot, TURN_SPEED * delta).get_euler()
	
	if is_swimming:
		if is_hunting and SystemGlobal.sub and not just_attacked:
			swim_target = SystemGlobal.sub.global_position
		velocity = (global_position.direction_to(swim_target) * SPEED * delta)
		velocity += offset_dir * 1.0 * delta
		_has_arrived_at_target()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta)
		
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = clampf(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.z = clampf(velocity.z, -MAX_SPEED, MAX_SPEED)
	move_and_slide()

func _navcast():
	var dist = 0.0
	for node_group in nav_casts.get_children():
		for cast in node_group.get_children():
			if cast.is_colliding():
				var cast_dist = (global_position - cast.get_collision_point()).length()
				if cast_dist > dist:
					dist = cast_dist
					offset_dir = (global_position - cast.get_collision_point()).normalized()
	
func _on_timer_timeout():
	if is_hunting and SystemGlobal.sub:
		swim_to_pos(SystemGlobal.sub.global_position)
	else:
		go_to_random_location(SWIM_DISTANCE)

func _on_nav_timer_timeout():
	_navcast()
	nav_timer.start()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		is_hunting = false
		just_attacked = true
		go_to_random_location(ATTACK_SWIM_DISTANCE)


func _on_area_3d_body_entered(body):
	if body == SystemGlobal.sub and is_hunting and not just_attacked:
		_attack()
	else:
		go_to_random_location(SWIM_DISTANCE)
