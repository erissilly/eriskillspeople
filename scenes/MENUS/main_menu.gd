extends Control

@onready var sprite: AnimatedSprite2D = $PlayerSprite

@onready var start: Button = $MarginContainer/HBoxContainer/Start
@onready var options: Control = $Options
@onready var confirm: Control = $Confirm
@onready var yes: Button = confirm.find_child("yes",true,false)
@onready var no: Button = confirm.find_child("no",true,false)
@onready var main_menu_buttons: HBoxContainer = $MarginContainer/HBoxContainer
@onready var continuebutton: Button = $MarginContainer/HBoxContainer/Continue
@onready var jumpsound: AudioStreamPlayer = $jumpsound

var last_button: Control
var first_focus = true


func _ready():
	sprite.global_position = start.global_position + Vector2(start.size.x / 2,start.size.y - 30)
	for button in $MarginContainer/HBoxContainer.get_children():
		if button is Button:
			button.focus_entered.connect(_on_button_focus.bind(button))
	last_button = start
	if Global.level < 2:
		continuebutton.disabled = true
	else:
		continuebutton.disabled = false
	yes.pressed.connect(_on_yes_pressed)
	no.pressed.connect(_on_no_pressed)
	
	#evil line of code
	options.visibility_changed.connect(func(): 
		if options.visible:
			var f = get_viewport().gui_get_focus_owner()
			if f:
				last_button = f
		main_menu_buttons.visible = not options.visible
		sprite.visible = not options.visible
	)
	confirm.visibility_changed.connect(func():
		if confirm.visible:
			var e = get_viewport().gui_get_focus_owner()
			if e:
				last_button = e
		main_menu_buttons.visible = not confirm.visible
		sprite.visible = not confirm.visible
		var showingtree := is_visible_in_tree()
		get_tree().paused = true
	)
	#past evil line of code...
	
	confirm.hide()
	options.hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	options.option_close.connect(_on_options_closed)
	start.grab_focus.call_deferred()



func _on_options_closed():
	main_menu_buttons.show()

	last_button.grab_focus.call_deferred()

#ANIAMTION SPRITE THINGY >>>>>>>>>>>>>>>>>>>>>>>>>>

func _on_button_focus(button: Button):
	var target = (button.global_position + Vector2(button.size.x / 2,button.size.y - 30)).round()
	if first_focus:
		first_focus= false
		sprite.global_position = target
		return
	if target.x < sprite.global_position.x:
		sprite.play("idle_flip")
	elif target.x > sprite.global_position.x:
		sprite.play("idle")
	var tween = create_tween()
	jumpsound.play()
	tween.tween_property(sprite, "global_position",target, 0.2)
	var jump = create_tween()
	jump.tween_property(sprite, "offset:y", -15, 0.1)
	jump.tween_property(sprite, "offset:y", 0, 0.1)


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
	get_tree().paused = false
	Global.reset_game()
	SceneTransition.start_scene("res://scenes/rooms/mainroom.tscn")

func _on_no_pressed() -> void:
	confirm.hide()
	get_tree().paused = false
	main_menu_buttons.show()
	options.set_process_unhandled_input(true)
	start.grab_focus.call_deferred()

func _on_continue_pressed() -> void:
	Global.enemydead = 0
	for e in get_tree().get_nodes_in_group("enemy"):
		e.queue_free()
	SceneTransition.start_scene("res://scenes/rooms/mainroom.tscn")



func _on_options_pressed() -> void:
	last_button = get_viewport().gui_get_focus_owner()
	options.show()
	main_menu_buttons.hide()
	
	


func _on_quit_pressed() -> void:
	get_tree().quit()
