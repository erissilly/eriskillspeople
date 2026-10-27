extends Control

signal option_close

@onready var back: Button = $CenterContainer/VBoxContainer/Back
@onready var backtomenu: Button = $CenterContainer/VBoxContainer/Backtomenu
@onready var fullscreen: CheckButton = $CenterContainer/VBoxContainer/fullscreen

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	back.pressed.connect(stupidoptionstartfix)
	visibility_changed.connect(_on_visibility_changed)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		if visible == true:
			hide()
			option_close.emit()
		else:
			visible = !visible
		
func stupidoptionstartfix():
	hide()
	option_close.emit()
		
		


func _on_backtomenu_pressed() -> void:
	stupidoptionstartfix()
	Global.enemydead = 0
	SceneTransition.start_scene("res://scenes/MENUS/main_menu.tscn")

func _on_visibility_changed() -> void:
	var showing := is_visible_in_tree()
	get_tree().paused = showing
	if showing:
		back.grab_focus.call_deferred() 






func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		var base := Vector2i(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"))
		DisplayServer.window_set_size(base * 3)
