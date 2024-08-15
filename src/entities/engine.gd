extends StaticBody3D

const REPAIR_SPEED = 0.1

@onready var engine  = $MeshInstanceEngine
@onready var label = $SubViewport/ScreenControl/Label

var targeted = false
var held_button = false

func hold_button():
	held_button = true

func release_button():
	held_button = false

func _physics_process(delta):
	if SystemGlobal.sub:
		label.text = "Leaks: " + str(snapped(SystemGlobal.sub.leaks, 0.01)) + "\nFlood: " + str(snapped(SystemGlobal.sub.water_level * 100, 0.1)) + "%"
		
	if SystemGlobal.sub and held_button:
		if SystemGlobal.sub.leaks > 0:
			SystemGlobal.sub.leaks -= REPAIR_SPEED * delta
		else:
			SystemGlobal.sub.leaks = 0
	
func change_targeted(is_targeted):
	if targeted != is_targeted:
		targeted = is_targeted
		engine.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)

