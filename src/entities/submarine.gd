extends CharacterBody3D


const SPEED = 5.0
const ASCENT_VELOCITY = 4.5

func _init():
	velocity.x = randf_range(-5.0, 5.0)
	velocity.y = randf_range(-5.0, 5.0)
	velocity.z = randf_range(-5.0, 5.0)
	print(velocity)

func _physics_process(_delta):
	move_and_slide()
