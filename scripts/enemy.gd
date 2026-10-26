class_name Enemy extends Area2D

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var spr: AnimatedSprite2D = $AnimatedSprite2D
@export var indexnr:= 1

@onready var alive = true

func _ready() -> void:
	spr.play(str(indexnr))
	Global.attacked.connect(_on_attacked)

func _on_attacked(target: Enemy) -> void:
	if target == self && alive:
		spr.play("dead")
		alive = false
		Global.attacked.disconnect(_on_attacked)
		
	else:
		return
		
