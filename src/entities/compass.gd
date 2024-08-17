extends Node3D

const TURN_SPEED = 1.0

@onready var dial = $dial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if SystemGlobal.checkpoints.size() > SystemGlobal.next_checkpoint:
		if SystemGlobal.checkpoints[SystemGlobal.next_checkpoint]:
			var tar = SystemGlobal.checkpoints[SystemGlobal.next_checkpoint]
			var tar_rot = Quaternion(dial.basis.orthonormalized())
			dial.look_at(dial.global_transform.origin + (global_position - tar.global_position).normalized(), Vector3.UP)
			var rot = Quaternion(dial.basis.orthonormalized())
			dial.rotation = tar_rot.slerp(rot, TURN_SPEED * delta).get_euler()
			dial.rotation.x = 0.0
			dial.rotation.z = 0.0
