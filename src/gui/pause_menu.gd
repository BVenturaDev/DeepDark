extends Control

func _on_restart_button_pressed():
	SystemGlobal.restart_game()

func _on_menu_button_pressed():
	print("Main Menu")

func _on_reload_button_pressed():
	SystemGlobal.reload_checkpoint()

func _on_options_button_pressed():
	pass # Replace with function body.
