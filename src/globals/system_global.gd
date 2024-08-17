extends Node

const DEBUG_MODE = true

var sub
var sonar
var sonar_casts
var screen
var engine
var compass
var player
var eels = []
var checkpoints = []
var next_checkpoint = 0
var last_checkpoint = 3 #-1
var final_checkpoint = 4
var checkpoint_load = false

func _reset_vars():
	get_tree().paused = false
	sub = null
	sonar = null
	sonar_casts = null
	screen = null
	engine = null
	player = null
	eels.clear()
	checkpoints.clear()
	next_checkpoint = 0
	last_checkpoint = -1
	checkpoint_load = false

func reload_checkpoint():
	if last_checkpoint == -1:
		restart_game()
	else:
		print("Reload Checkpoint")
		get_tree().paused = false
		sub = null
		sonar = null
		sonar_casts = null
		screen = null
		engine = null
		player = null
		eels.clear()
		checkpoints.clear()
		next_checkpoint = last_checkpoint + 1
		get_tree().reload_current_scene()
		checkpoint_load = true
	
func restart_game():
	print("Restart Game")
	_reset_vars()
	get_tree().reload_current_scene()
	
func main_menu():
	_reset_vars()
