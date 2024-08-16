extends CharacterBody3D

const SPEED = 1.0
const ASCENT_SPEED = 0.5
const STOP_SPEED = 1.5
const TURN_SPEED = 0.5
const MAX_SPEED = 10.0
const WATER_HEIGHT = 2.0
const WATER_SPEED = 0.025
const SINK_SPEED = 5.0
const SINK_SFX_MULTIPLIER = 0.0

@onready var player = $Player
@onready var headlights = $Headlights
@onready var eel_timer = $Eel_Update_Timer
@onready var water = $Water
@onready var sinking_sfx = $SinkingStreamPlayer
@onready var leak_sfx = $LeakStreamPlayer
@onready var floor_sfx = $FloorStreamPlayer
@onready var rattle_sfx = $RattleStreamPlayer

var input_dir = Vector2()
var ascent_normal = 0.0

var eels_in_range = []

var leaks = 0.0
var water_level = 0.0

func _ready():
	SystemGlobal.sub = self
	SystemGlobal.sonar_casts = $SonarCasts

func _calc_leaks(delta):
	if water_level > 0:
		if water_level >= 0.59:
			SystemGlobal.player.is_under_water = true
		else:
			SystemGlobal.player.is_under_water = false
		water.visible = true
	else:
		water.visible = false
	
	if leaks > 0:
		if not leak_sfx.playing:
			leak_sfx.play()
		if SystemGlobal.engine:
			if not SystemGlobal.engine.pump_sfx.playing:
				SystemGlobal.engine.pump_sfx.stop()
		water_level += WATER_SPEED * leaks * delta
	elif water_level > 0.0:
		if leak_sfx.playing:
			leak_sfx.stop()
		if SystemGlobal.engine:
			if not SystemGlobal.engine.pump_sfx.playing:
				SystemGlobal.engine.pump_sfx.play()
		water_level -= WATER_SPEED * delta
	else:
		if leak_sfx.playing:
			leak_sfx.stop()
		if SystemGlobal.engine:
			if not SystemGlobal.engine.pump_sfx.playing:
				SystemGlobal.engine.pump_sfx.stop()
	water_level = clampf(water_level, 0.0, 1.0)
	water.position.y = (WATER_HEIGHT * water_level) - 1.0
		
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
	
	_calc_leaks(delta)
	
	if is_on_ceiling():
		if not floor_sfx.playing:
			floor_sfx.play()
		velocity.y += -0.1
	elif is_on_floor():
		if not floor_sfx.playing:
			floor_sfx.play()
		velocity.y += 0.1
	else:
		if floor_sfx.playing:
			floor_sfx.stop()
	
	if input_dir:
		rotate_object_local(Vector3(0.0, 1.0, 0.0), -TURN_SPEED * delta * input_dir.x)
		velocity -= transform.basis.x * SPEED * delta * input_dir.y
	if ascent_normal != 0.0:
		if SystemGlobal.engine:
			if not SystemGlobal.engine.ballast_sfx.playing:
				SystemGlobal.engine.ballast_sfx.play()
	elif SystemGlobal.engine:
		if SystemGlobal.engine.ballast_sfx.playing:
			SystemGlobal.engine.ballast_sfx.stop()
		
		velocity += transform.basis.y * ASCENT_SPEED * delta * ascent_normal
	else:
		velocity.x = move_toward(velocity.x, 0, STOP_SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, STOP_SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, STOP_SPEED * delta)
	
	if water_level > 0:
		if not is_on_floor():
			if not sinking_sfx.playing:
				sinking_sfx.play()
			#sinking_sfx.volume_db = SINK_SFX_MULTIPLIER * water_level
		elif sinking_sfx.playing:
			sinking_sfx.stop()
		velocity.y += -SINK_SPEED * water_level * delta
	else:
		if sinking_sfx.playing:
			sinking_sfx.stop()
	
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.z = clampf(velocity.z, -MAX_SPEED, MAX_SPEED)
	velocity.y = clampf(velocity.y, -MAX_SPEED / 2.0, MAX_SPEED / 2.0)
	
	if velocity.length() > 0:
		if not rattle_sfx.playing:
			rattle_sfx.play()
	else:
		rattle_sfx.stop()
	move_and_slide()

func _input(event):
	if event.is_action_pressed("sub_lights") and SystemGlobal.DEBUG_MODE:
		toggle_headlights()

func toggle_headlights():
	headlights.set_visible(!headlights.visible)
	if not headlights.visible:
		update_eels()

func update_eels():
	for eel in eels_in_range:
		if not eel.is_in_aggro_range:
			if headlights.visible or SystemGlobal.screen.is_light_on:
				eel.is_hunting = true
			else:
				eel.is_hunting = false
		
func _on_area_3d_body_entered(body):
	if body.is_in_group("eels"):
		eels_in_range.append(body)
		update_eels()

func _on_area_3d_body_exited(body):
	if body.is_in_group("eels"):
		eels_in_range.remove_at(eels_in_range.find(body))
		update_eels()

func _on_eel_update_timer_timeout():
	update_eels()
	eel_timer.start()

func _on_aggro_area_3d_body_entered(body):
	if body.is_in_group("eels"):
		body.is_hunting = true
		body.is_in_aggro_range = true

func _on_aggro_area_3d_body_exited(body):
	if body.is_in_group("eels"):
		body.is_hunting = false
		body.is_in_aggro_range = false
