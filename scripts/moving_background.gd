extends Node2D

@onready var sprites: Array[Sprite2D] = [$tree, $eris, $leaves]
@onready var timer: Timer = $Timer

var origins: Array[Vector2] = []

func _ready() -> void:
	for i in sprites:
		origins.append(i.position)
	timer.start()

func _on_timer_timeout() -> void:
	var check = randi_range(0,sprites.size()-1)
	sprites[check].position = origins[0] + Vector2(randf_range(0, 2), randf_range(0, 2))
