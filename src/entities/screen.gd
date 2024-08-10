@tool
extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$SubViewport/Node3DCameras.global_transform = global_transform
