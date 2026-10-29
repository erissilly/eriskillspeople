extends Node2D

@export var spawn_position: Vector2


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if is_instance_valid(Global.current_room):
			Global.current_room.queue_free()
			Global.current_room = null
		SceneTransition.start_scene("res://scenes/MENUS/introreverse.tscn")
