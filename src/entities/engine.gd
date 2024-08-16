extends StaticBody3D

const REPAIR_SPEED = 0.1
const MOTOR_VOLUME_MULTIPLIER = 1.0

@onready var engine  = $MeshInstanceEngine
@onready var label = $SubViewport/ScreenControl/Label
@onready var motor_sfx = $MotorStreamPlayer3D
@onready var pump_sfx = $PumpStreamPlayer3D
@onready var ballast_sfx = $BallastStreamPlayer3D
@onready var repair_sfx = $RepairStreamPlayer3D

var targeted = false
var held_button = false

func _ready():
	SystemGlobal.engine = self

func hold_button():
	held_button = true

func release_button():
	held_button = false

func _physics_process(delta):
	if SystemGlobal.sub:
		if SystemGlobal.sub.input_dir.length() > 0:
			if not motor_sfx.playing:
				motor_sfx.play()
			motor_sfx.volume_db = MOTOR_VOLUME_MULTIPLIER * SystemGlobal.sub.input_dir.length()
		elif motor_sfx.playing:
			motor_sfx.stop()
		label.text = "Leaks: " + str(snapped(SystemGlobal.sub.leaks, 0.01)) + "\nFlood: " + str(snapped(SystemGlobal.sub.water_level * 100, 0.1)) + "%"
		
	if SystemGlobal.sub and held_button:
		if SystemGlobal.sub.leaks > 0:
			if not repair_sfx.playing:
				repair_sfx.play()
			SystemGlobal.sub.leaks -= REPAIR_SPEED * delta
		else:
			if repair_sfx.playing:
				repair_sfx.stop()
			SystemGlobal.sub.leaks = 0
	
func change_targeted(is_targeted):
	if targeted != is_targeted:
		targeted = is_targeted
		engine.get_active_material(0).next_pass.set("shader_parameter/is_targeted", targeted)
