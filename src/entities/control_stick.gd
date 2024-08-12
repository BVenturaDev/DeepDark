extends StaticBody3D

@onready var Pad = $MeshInstance3DPad
@onready var Stick = $TiltControl/MeshInstanceStick
@onready var Ball = $TiltControl/MeshInstanceBall
@onready var anim = $AnimationTree

var targeted = false

func change_targeted(is_targeted):
	if targeted != is_targeted:
		targeted = is_targeted
		Pad.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)
		Stick.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)
		Ball.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)

func tilt_controller(pos):
	anim.set("parameters/blend_position", pos)
	if SystemGlobal.sub:
		SystemGlobal.sub.input_dir = pos

# Called when the node enters the scene tree for the first time.
func _ready():
	tilt_controller(Vector2())
