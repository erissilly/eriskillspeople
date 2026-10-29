extends Enemy



@onready var rotatespr: AnimatedSprite2D = $AnimatedSprite2D
@onready var look: AnimatedSprite2D = $AnimatedSprite2D/LOOK/Sprite2D
@onready var lookarea: Area2D = $AnimatedSprite2D/LOOK


@onready var timer: Timer = $Timer

func rotatemeow():
	if not alive:
		look.hide()
		return
	rotatespr.rotation_degrees += 90
		
	timer.start()



func _on_timer_timeout() -> void:
	if not alive:
		look.hide()
		return
	rotatemeow()

func _on_attacked(target: Enemy) -> void:
	if target == self && alive:
		timer.stop()
		spr.play("dead")
		await get_tree().physics_frame
		rotatespr.rotation_degrees = 0
		look.hide()
		lookarea.set_deferred("monitoring", false)
	super(target)


func _on_look_body_entered(body: Node2D) -> void:
	if body is Player:
		if alive:
			look.play("found")
			timer.stop()
			Global.sawplayer.emit()
