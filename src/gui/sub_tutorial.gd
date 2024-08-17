extends Control

@onready var step_1 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer
@onready var step_2 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer2
@onready var step_3 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer3
@onready var step_4 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer4
@onready var step_5 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer5

@onready var step_check_1 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/SmallPanelContainer/MarginContainer/HBoxContainer/TextureRect
@onready var step_check_2 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer2/SmallPanelContainer/MarginContainer/HBoxContainer/TextureRect2
@onready var step_check_3 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer3/SmallPanelContainer/MarginContainer/HBoxContainer/TextureRect3
@onready var step_check_4 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer4/SmallPanelContainer/MarginContainer/HBoxContainer/TextureRect4
@onready var step_check_5 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer5/SmallPanelContainer/MarginContainer/HBoxContainer/TextureRect5

@onready var timer1 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/Timer1
@onready var timer2 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer2/Timer2
@onready var timer3 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer3/Timer3
@onready var timer4 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer4/Timer4
@onready var timer5 = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer5/Timer5

func _ready():
	if SystemGlobal.checkpoint_load:
		visible = false

func complete_step(in_step):
	if in_step == 1:
		step_check_1.visible = true
		timer1.start()
	elif in_step == 2:
		step_check_2.visible = true
		timer2.start()
	elif in_step == 3:
		step_check_3.visible = true
		timer3.start()
	elif in_step == 4:
		step_check_4.visible = true
		timer4.start()
	elif in_step == 5:
		step_check_5.visible = true
		timer5.start()

func _on_timer_timeout():
	step_1.visible = false

func _on_timer_2_timeout():
	step_2.visible = false

func _on_timer_3_timeout():
	step_3.visible = false

func _on_timer_4_timeout():
	step_4.visible = false

func _on_timer_5_timeout():
	visible = false
