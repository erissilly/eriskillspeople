class_name Enemy extends Area2D

@onready var checkifplayernear: Area2D = $checkifplayernear
@onready var spr: AnimatedSprite2D = $AnimatedSprite2D
@export var indexnr:= 1
@export var fliphorizontal := false
@export var squeekpitch:= 3.00

@onready var squeek: AudioStreamPlayer2D = $squeek


@onready var alive = true


func _ready() -> void:
	spr.play(str(indexnr))
	squeek.pitch_scale = squeekpitch
	spr.flip_h = fliphorizontal
	Global.attacked.connect(_on_attacked)

func _on_attacked(target: Enemy) -> void:
	if target == self && alive:
		spr.play("dead_" + str(indexnr))
		await get_tree().create_timer(0.5).timeout
		Global.enemydead += 1
		alive = false
		checkifplayernear.queue_free()
		Global.attacked.disconnect(_on_attacked)
		set_deferred("collision_layer", 0)
		
	else:
		return
		


func _on_checkifplayernear_body_entered(body: Node2D) -> void:
	if body is Player && alive:
		var tween = get_tree().create_tween()
		var jump = spr.position.y - 2
		squeek.play()
		tween.tween_property(spr, "position:y", jump, 0.2)
		spr.play(str(indexnr) + "_scared")
		await tween.finished
		spr.position.y += 2
		


func _on_checkifplayernear_body_exited(body: Node2D) -> void:
	if body is Player && alive:
		spr.play(str(indexnr))
