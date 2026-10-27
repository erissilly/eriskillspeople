extends Node2D

@onready var transition: ColorRect = $ColorRect
@onready var options: Control = $Options


var what_room = str(Global.level)

func load_room(room_to_load : String) -> void:
	var levelload = "res://scenes/rooms/" + room_to_load + ".tscn"
	var room_scene = load(levelload)
	if room_scene != null:
		var room = room_scene.instantiate()
		get_parent().add_child.call_deferred(room)
	elif room_scene == null:
		return

func _ready() -> void:
	load_room(what_room)
	options.visible = false
