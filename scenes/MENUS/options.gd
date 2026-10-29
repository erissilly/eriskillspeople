extends Control

signal option_close

@onready var MusicSlider: HSlider = $CenterContainer/VBoxContainer/MusicSlider
@onready var SoundSlider: HSlider = $CenterContainer/VBoxContainer/SoundSlider
@onready var back: Button = $CenterContainer/VBoxContainer/MarginContainer/VBoxContainer/Back
@onready var fullscreen: CheckButton = $CenterContainer/VBoxContainer/fullscreen
@onready var backtomenu: Button = $CenterContainer/VBoxContainer/MarginContainer/VBoxContainer/Backtomenu
@onready var preview_sfx: AudioStreamPlayer = $Preview_SFX
@onready var preview_bgm: AudioStreamPlayer = $Preview_BGM

var bgmindex = AudioServer.get_bus_index("BGM")
var sfxindex = AudioServer.get_bus_index("SFX")

func _ready() -> void:
	if get_parent().name == "MainMenu":
		backtomenu.hide()
	else:
		backtomenu.show()
	MusicSlider.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(bgmindex)))
	SoundSlider.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(sfxindex)))
	fullscreen.set_pressed_no_signal(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	process_mode = Node.PROCESS_MODE_ALWAYS
	back.pressed.connect(stupidoptionstartfix)
	visibility_changed.connect(_on_visibility_changed)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		if visible == true:
			hide()
			option_close.emit()
		elif Global.can_open_options and not SceneTransition.tp:
			show()
		
func stupidoptionstartfix():
	hide()
	option_close.emit()
		
		


func _on_backtomenu_pressed() -> void:
	stupidoptionstartfix()
	Global.enemydead = 0
	if is_instance_valid(Global.current_room):
		Global.current_room.queue_free()
		Global.current_room = null
	SceneTransition.start_scene("res://scenes/MENUS/main_menu.tscn")

func _on_visibility_changed() -> void:
	if not is_inside_tree():
		return
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




func _on_music_slider_value_changed(value: float) -> void:
	preview_bgm.volume_db = linear_to_db(value)
	preview_bgm.play()
	AudioServer.set_bus_volume_db(bgmindex, linear_to_db(value))


func _on_sound_slider_value_changed(value: float) -> void:
	preview_sfx.volume_db = linear_to_db(value)
	preview_sfx.play()
	AudioServer.set_bus_volume_db(sfxindex, linear_to_db(value))
