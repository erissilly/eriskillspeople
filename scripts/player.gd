class_name Player extends CharacterBody2D

@onready var music: AudioStreamPlayer = $"../music"
@onready var jump: AudioStreamPlayer2D = $jump
@onready var hit: AudioStreamPlayer2D = $hit
@onready var timer: Timer = $TILEWAIT
@onready var spr: AnimatedSprite2D = $AnimatedSprite2D
@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right
@onready var up: RayCast2D = $up
@onready var down: RayCast2D = $down

enum State { IDLE, WALKING, ATTACKING }
var state := State.IDLE

const tile_size = 16


func tile_move():
	if state == State.IDLE:
		spr.play("idle")
		var diry = int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
		var dirx = int(Input.is_action_just_pressed("right"))- int(Input.is_action_just_pressed("left"))
		
		
		
		if dirx == -1 && left.is_colliding():
			return
		elif dirx == 1 && right.is_colliding():
			return
		elif diry == -1 && up.is_colliding():
			return
		elif diry == 1 && down.is_colliding():
			return
			
			
		if dirx != 0:
			state = State.WALKING
			var dirgoto = position.x + dirx * tile_size
			spr.play("walk")
			jump.play()
			var tween = create_tween()
			spr.position.y -= 1
			tween.tween_property(self,"position:x", dirgoto, 0.3)
			await tween.finished
			spr.position.y += 1
			state = State.IDLE
			
		elif diry != 0:
			state = State.WALKING
			var dirgoto = position.y + diry * tile_size
			spr.play("walk")
			jump.play()
			var tween = create_tween()
			spr.position.y -= 1
			tween.tween_property(self,"position:y", dirgoto, 0.3)
			await tween.finished
			spr.position.y += 1
			state = State.IDLE
		
		
func _physics_process(delta: float) -> void:
	tile_move()



func _on_attackarea_area_entered(area: Area2D) -> void:
	if area is Enemy:
		var checkifdead = Global.attacked.is_connected(area._on_attacked)
		if checkifdead:
			while state != State.IDLE:
				await get_tree().physics_frame
			music.stop()
			state = State.ATTACKING
			spr.play("attack")
			await get_tree().create_timer(0.85).timeout
			hit.play()
			await spr.animation_finished
			Global.attacked.emit(area)
			await get_tree().create_timer(0.85).timeout
			music.play()
			state = State.IDLE
