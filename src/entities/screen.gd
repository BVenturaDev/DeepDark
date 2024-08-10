@tool
extends Node3D

var cameras = []
var camera_labels = ["Port", "Starboard", "Stern", "Floor", "Roof"]
var cam_num = 0

@onready var label = $SubViewport/ScreenControl/Label

func _ready():
	# Setup Screen
	$MeshInstanceScreen.get_active_material(0).set("shader_parameter/screen_tex", $SubViewport.get_texture())
	
	# Activate Cameras
	cameras.append_array($SubViewport/Node3DCameras.get_children())
	_activate_cam(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Make the cameras follow the sub
	$SubViewport/Node3DCameras.global_transform = global_transform

func _deactivate_cam(in_cam_num):
	if cameras[in_cam_num]:
		# Turn off Camera
		cameras[in_cam_num].current = false
		# Turn off Light
		cameras[in_cam_num].get_child(0).visible = false

func _activate_cam(in_cam_num):
	if cameras[in_cam_num]:
		# Turn on Camera
		cameras[in_cam_num].current = true
		# Turn on light
		cameras[in_cam_num].get_child(0).visible = true
		# Set Label
		label.text = camera_labels[in_cam_num]

func _input(event):
	# "," key
	if event.is_action_pressed("previous_camera"):
		# Turn off current camera
		_deactivate_cam(cam_num)
		# Decrease cam_num or reset
		if cam_num == 0:
			cam_num = cameras.size() - 1
		else:
			cam_num -= 1
		_activate_cam(cam_num)
	# "." key
	elif event.is_action_pressed("next_camera"):
		# Turn off current camera
		_deactivate_cam(cam_num)
		# Increase cam_num or reset
		if cam_num == cameras.size() - 1:
			cam_num = 0
		else:
			cam_num += 1
		_activate_cam(cam_num)
