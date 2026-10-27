extends Node2D

@onready var transition: ColorRect = $ColorRect

var what_room = str(Global.level)

func load_room(room_to_load : String) -> void:
	var levelload = "res://scenes/rooms/" + room_to_load + ".tscn"
	var room_scene = load(levelload)
	var room = room_scene.instantiate()
	get_parent().add_child.call_deferred(room)

func _ready() -> void:
	load_room(what_room)
