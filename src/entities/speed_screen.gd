extends Node3D

@onready var screen = $Screen/MeshInstanceScreen
@onready var label = $SubViewport/ScreenControl/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	# Setup Screen
	screen.get_active_material(0).set("shader_parameter/screen_tex", $SubViewport.get_texture())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if SystemGlobal.sub:
		var speed = Vector2(SystemGlobal.sub.velocity.x, SystemGlobal.sub.velocity.z)
		label.text = "Speed: " + str(snapped(speed.length(), 0.01)) + "\nClimb: " + str(snapped(SystemGlobal.sub.velocity.y, 0.01))
