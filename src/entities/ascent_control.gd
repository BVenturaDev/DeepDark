extends StaticBody3D

@onready var Pad = $MeshInstance3DPad
@onready var Stick = $TiltControl/MeshInstanceStick
@onready var Stick2 = $TiltControl/MeshInstanceStick2
@onready var Stick3 = $TiltControl/MeshInstanceStick3
@onready var anim = $AnimationTree

var targeted = false

func change_targeted(is_targeted):
	if targeted != is_targeted:
		targeted = is_targeted
		Pad.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)
		Stick.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)
		Stick2.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)
		Stick3.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)
		if not targeted:
			tilt_controller(Vector2())

func tilt_controller(pos):
	anim.set("parameters/blend_position", pos.y)
	if SystemGlobal.sub:
		SystemGlobal.sub.ascent_normal = pos.y

# Called when the node enters the scene tree for the first time.
func _ready():
	tilt_controller(Vector2())
