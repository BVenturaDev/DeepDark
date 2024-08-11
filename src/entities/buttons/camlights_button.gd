extends StaticBody3D

@onready var base = $MeshInstanceBase
@onready var button = $MeshInstanceButton
@onready var anim = $AnimationPlayer

var sub
var targeted = false

func press_button():
	if sub:
		anim.play("press_button")
		sub.toggle_headlights()
	
func change_targeted(is_targeted):
	if targeted != is_targeted:
		targeted = is_targeted
		base.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)
		button.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)

# Called when the node enters the scene tree for the first time.
func _ready():
	sub = get_tree().get_root().get_child(0).get_node("Submarine")
