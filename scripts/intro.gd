extends Control

@onready var dia: CanvasLayer = $DialogueBox
@onready var _1: TextureRect = $"1"
@onready var _2: TextureRect = $"2"
@onready var _3: TextureRect = $"3"
@onready var _4: TextureRect = $"4"
@onready var scary: AudioStreamPlayer = $scary
@onready var music: AudioStreamPlayer = $music

var fadein : Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dia.dialog_end.connect(_on_dialog_end)
	dia.line_started.connect(_on_line_change)

	

func _on_dialog_end():
	Global.firsttimeplaying = false
	SceneTransition.start_scene("res://scenes/rooms/mainroom.tscn")


func _on_line_change(id):
	_1.hide()
	_2.hide()
	_3.hide()
	_4.hide()
	if id == 0:
		scary.play()
		_1.show()
	elif id == 1:
		_2.show()
	elif id == 2:
		_3.show()
	elif id == 4:
		scary.stop()
		_4.show()
		music.play()
	else: return
