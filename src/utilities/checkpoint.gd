extends Node3D

@export var checkpoint_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SystemGlobal.checkpoints.append(self)

func _on_area_3d_body_entered(body):
	if SystemGlobal.sub:
		if body == SystemGlobal.sub:
			SystemGlobal.last_checkpoint = checkpoint_id
			SystemGlobal.next_checkpoint = checkpoint_id + 1
