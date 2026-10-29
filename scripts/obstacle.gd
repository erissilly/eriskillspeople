class_name Obstacle extends Area2D

@onready var obspr: AnimatedSprite2D = $AnimatedSprite2D

@export var whattoplay := 1

func _ready() -> void:
	obspr.play(str(whattoplay))
