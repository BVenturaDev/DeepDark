extends Node3D

@onready var anim = $eel_mesh/AnimationPlayer

var anim_states = ["idle", "swim", "attack"]
var anim_state = 0
var secondary_anim = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_anim_state(in_state):
	if in_state < anim_states.size() and in_state >= 0:
		anim_state = in_state
		_handle_anim_state()

func _handle_anim_state():
	if anim_state <= 1:
		anim.speed_scale = 1.0
		if not secondary_anim:
			anim.play(anim_states[anim_state])
			secondary_anim = true
		else:
			anim.play(anim_states[anim_state] + "_2")
			secondary_anim = false
	elif anim_state == 2:
		anim.speed_scale = 2.0
		anim.play("attack")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not anim.is_playing():
		_handle_anim_state()
