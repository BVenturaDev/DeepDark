extends StaticBody3D

@onready var base = $MeshInstanceBase
@onready var button = $MeshInstanceButton
@onready var anim = $AnimationPlayer

var targeted = false

func press_button():
	if SystemGlobal.screen:
		anim.play("press_button")
		SystemGlobal.screen.previous_cam()
	
func change_targeted(is_targeted):
	if targeted != is_targeted:
		targeted = is_targeted
		base.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)
		button.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)
