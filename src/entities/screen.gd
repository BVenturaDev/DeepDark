@tool
extends Node3D
var cameras = []
var cam_num = 0

func _ready():
	cameras.append_array($SubViewport/Node3DCameras.get_children())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$SubViewport/Node3DCameras.global_transform = global_transform

func _input(event):  		
	if event.is_action_pressed("previous_camera"):
		if cam_num == 0:
			cam_num = cameras.size() - 1
		else:
			cam_num -= 1
		if cameras[cam_num]:
			cameras[cam_num].current = true
	elif event.is_action_pressed("next_camera"):
		if cam_num == cameras.size() - 1:
			cam_num = 0
		else:
			cam_num += 1
		if cameras[cam_num]:
			cameras[cam_num].current = true
