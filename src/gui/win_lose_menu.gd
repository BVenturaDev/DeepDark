extends Control

func _on_reload_button_pressed():
	SystemGlobal.reload_checkpoint()

func _on_restart_button_pressed():
	SystemGlobal.restart_game()

func _on_menu_button_pressed():
	SystemGlobal.main_menu()

func _on_quit_button_pressed():
	get_tree().quit()
