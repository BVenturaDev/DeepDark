extends StaticBody3D

@onready var Pad = $MeshInstance3DPad
@onready var Stick = $TiltControl/MeshInstanceStick
@onready var Ball = $TiltControl/MeshInstanceBall
@onready var anim = $AnimationTree

var sub
var targeted = false

func change_targeted(is_targeted):
	if targeted != is_targeted:
		targeted = is_targeted
		Pad.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)
		Stick.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)
		Ball.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)

func tilt_controller(pos):
	anim.set("parameters/blend_position", pos)
	sub.input_dir = pos

# Called when the node enters the scene tree for the first time.
func _ready():
	sub = get_tree().get_root().get_child(0).get_node("Submarine")
	tilt_controller(Vector2())
