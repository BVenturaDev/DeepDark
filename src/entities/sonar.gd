extends Node3D

@onready var sonar_tex = $SubViewport/ScreenControl/ColorRectSonar

# Called when the node enters the scene tree for the first time.
func _ready():
	# Setup Screen
	$MeshInstanceScreen.get_active_material(0).set("shader_parameter/screen_tex", $SubViewport.get_texture())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
