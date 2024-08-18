extends Control

@onready var slider = $SettingsPanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/HSlider


func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -20 + (slider.value - slider.max_value))

func _on_play_button_pressed():
	SystemGlobal.play_game()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_check_box_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 

func _on_h_slider_drag_ended(value_changed):
	if value_changed:
		if slider.value == 0:
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		else:
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -20 + (slider.value - slider.max_value))
