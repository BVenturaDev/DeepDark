extends Node3D

@onready var anim = $eel_mesh/AnimationPlayer

var track1 = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not anim.is_playing():
		if track1:
			anim.play("idle")
			track1 = false
		else:
			anim.play("idle_2")
			track1 = true
