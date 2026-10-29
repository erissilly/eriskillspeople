extends Node2D

@onready var transition: ColorRect = $ColorRect
@onready var options: Control = $Options

var what_room = str(Global.level)

func load_room(room_to_load : String) -> void:
	if Global.firsttimeplaying:
		get_tree().change_scene_to_file("res://scenes/MENUS/intro.tscn")
		
	else:
		var levelload = "res://scenes/rooms/" + room_to_load + ".tscn"
		var room_scene = load(levelload)
		if room_scene != null:
			if is_instance_valid(Global.current_room):
				Global.current_room.queue_free()
			var room = room_scene.instantiate()
			get_parent().add_child.call_deferred(room)
			Global.current_room = room
			var player = get_tree().get_first_node_in_group("Player")
			if player:
				player.global_position = room.spawn_position
		elif room_scene == null:
			return

func _ready() -> void:
	load_room(what_room)
	options.visible = false
