extends Node3D

@export var checkpoint_id = 0
@onready var spawn_point = $SpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	SystemGlobal.checkpoints.append(self)

func _on_area_3d_body_entered(body):
	if SystemGlobal.sub and SystemGlobal.next_checkpoint <= checkpoint_id:
		if body == SystemGlobal.sub:
			SystemGlobal.compass.is_paused = true
			SystemGlobal.compass.timer.start()
			SystemGlobal.player.checkpoint_anim.play("checkpoint_anim")
			if checkpoint_id == 0:
				SystemGlobal.player.tut.complete_step(4)
				SystemGlobal.player.tut.step_5.visible = true
			if checkpoint_id == SystemGlobal.final_checkpoint:
				if SystemGlobal.player:
					SystemGlobal.player.win()
			else:
				SystemGlobal.last_checkpoint = checkpoint_id
				SystemGlobal.next_checkpoint = checkpoint_id + 1
