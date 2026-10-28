extends Control


@onready var start: Button = $MarginContainer/HBoxContainer/Start
@onready var options: Control = $Options
@onready var confirm: Control = $Confirm
@onready var yes: Button = confirm.find_child("yes",true,false)
@onready var no: Button = confirm.find_child("no",true,false)
@onready var main_menu_buttons: HBoxContainer = $MarginContainer/HBoxContainer
@onready var continuebutton: Button = $MarginContainer/HBoxContainer/Continue

var last_button: Control



func _ready():
	last_button = start
	if Global.level < 2:
		continuebutton.disabled = true
	else:
		continuebutton.disabled = false
	yes.pressed.connect(_on_yes_pressed)
	no.pressed.connect(_on_no_pressed)
	confirm.hide()
	options.hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	options.option_close.connect(_on_options_closed)
	start.grab_focus.call_deferred()


func _on_options_closed():
	main_menu_buttons.show()

	last_button.grab_focus.call_deferred()


# BUTTONS ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> meowmeowmeowmeow

func _on_start_pressed() -> void:
	if Global.level > 1:
		confirm.show()
		main_menu_buttons.hide()
		options.set_process_unhandled_input(false)
		no.grab_focus.call_deferred()
	else:
		Global.reset_game()
		SceneTransition.start_scene("res://scenes/rooms/mainroom.tscn")


func _on_yes_pressed() -> void:
	Global.reset_game()
	SceneTransition.start_scene("res://scenes/rooms/mainroom.tscn")

func _on_no_pressed() -> void:
	confirm.hide()
	main_menu_buttons.show()
	options.set_process_unhandled_input(true)
	start.grab_focus.call_deferred()

func _on_continue_pressed() -> void:
	SceneTransition.start_scene("res://scenes/rooms/mainroom.tscn")



func _on_options_pressed() -> void:
	last_button = get_viewport().gui_get_focus_owner()
	options.visible = true
	main_menu_buttons.visible= false
	
	


func _on_quit_pressed() -> void:
	get_tree().quit()
