extends Control

func _on_resume_button_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	SystemGlobal.player.mouse_mode = true
	SystemGlobal.player.pause_menu.visible = false
	get_tree().paused = false

func _on_reload_button_pressed():
	SystemGlobal.reload_checkpoint()

func _on_restart_button_pressed():
	SystemGlobal.restart_game()

func _on_menu_button_pressed():
	SystemGlobal.main_menu()

func _on_quit_button_pressed():
	get_tree().quit()

"""
func _input(event):
	# Escape Key Changes Mouse Mode
	if event.is_action_pressed("ui_escape") and not SystemGlobal.player.mouse_mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		SystemGlobal.player.mouse_mode = true
		SystemGlobal.player.pause_menu.visible = false
		get_tree().paused = false
"""
