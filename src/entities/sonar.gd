extends Node3D

@onready var sonar_tex = $SubViewport/ScreenControl/ColorRectSonar
@onready var sonar_shader = $SubViewport/ScreenControl/ColorRectSonar.material
@onready var timer = $Timer
@onready var label = $SubViewport/ScreenControl/Label
@onready var sub_gui = $SubViewport/ScreenControl/Center/GUIScale
@onready var ping_sound = $SonarStreamPlayer

var cur_pings = []
var ping_distance = 20.0

var view_angles = ["Side", "Front", "Top"]
var cur_view = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SystemGlobal.sonar = self
	
	# Setup Screen
	$sub_sonar_screen.get_active_material(0).set("shader_parameter/screen_tex", $SubViewport.get_texture())
	timer.connect("timeout", _on_timer_timeout)

func _on_timer_timeout():
	_ping_sonar()

func _ping_sonar():
	timer.start()
	if SystemGlobal.sonar_casts:
		ping_sound.play()
		cur_pings.clear()
		for node_group in SystemGlobal.sonar_casts.get_children():
			for cast in node_group.get_children():
				if cast.is_colliding() and cast.get_collider():
					cur_pings.append(cast.get_collision_point())
		if cur_pings:
			sonar_shader.set("shader_parameter/num_blips", cur_pings.size())
			sonar_shader.get("shader_parameter/blip_positions").clear()
			for ping in cur_pings:
				var ping_pos = ((SystemGlobal.sub.global_position - ping) / ping_distance).normalized()
				if cur_view == 0:
					sonar_shader.get("shader_parameter/blip_positions").append(Vector2(ping_pos.z, ping_pos.y))
				if cur_view == 1:
					sonar_shader.get("shader_parameter/blip_positions").append(Vector2(ping_pos.x, ping_pos.y))
				if cur_view == 2:
					sonar_shader.get("shader_parameter/blip_positions").append(Vector2(ping_pos.z, -ping_pos.x))

func previous_view():
	sub_gui.get_child(cur_view).visible = false
	if cur_view == 0:
		cur_view = view_angles.size() - 1
	else:
		cur_view -= 1
	label.text = view_angles[cur_view]
	sub_gui.get_child(cur_view).visible = true
	_ping_sonar()

func next_view():
	sub_gui.get_child(cur_view).visible = false
	if cur_view == view_angles.size() - 1:
		cur_view = 0
	else:
		cur_view += 1
	label.text = view_angles[cur_view]
	sub_gui.get_child(cur_view).visible = true
	_ping_sonar()

func _input(event):
	if SystemGlobal.DEBUG_MODE:
		# "[" key
		if event.is_action_pressed("previous_view"):
			previous_view()
		# "]" key
		elif event.is_action_pressed("next_view"):
			next_view()
