extends Control

func _on_restart_button_pressed():
	SystemGlobal.restart_game()

func _on_menu_button_pressed():
	print("Main Menu")
	pass # Replace with function body.


func _on_reload_button_pressed():
	SystemGlobal.reload_checkpoint()
