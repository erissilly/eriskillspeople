class_name Player extends CharacterBody2D

@onready var camera: Camera2D = $"../ShakeCamera"
@onready var music: AudioStreamPlayer = $"../music"
@onready var jump: AudioStreamPlayer2D = $jump
@onready var hit: AudioStreamPlayer2D = $hit
@onready var dead: AudioStreamPlayer2D = $dead
@onready var spr: AnimatedSprite2D = $AnimatedSprite2D
@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right
@onready var up: RayCast2D = $up
@onready var down: RayCast2D = $down
@onready var alive = true


var facing_left:= false

enum State { IDLE, WALKING, ATTACKING, DEAD }
var state := State.IDLE

const tile_size = 16

func _ready() -> void:
	Global.player = self
	for ray in [left,right,up,down]:
		ray.add_exception($attackarea)

func tile_move():
	if state == State.IDLE:
		if facing_left:
			spr.play("idle_flip")
		else:
			spr.play("idle")
		var diry = int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
		var dirx = int(Input.is_action_just_pressed("right"))- int(Input.is_action_just_pressed("left"))
		
		if dirx == -1 && left.is_colliding():
			if left.get_collider().is_in_group("enemy"):
				facing_left = true
				_on_attackarea_area_entered(left.get_collider())
			if not (left.get_collider() is Obstacle):
				return
		elif dirx == 1 && right.is_colliding():
			if right.get_collider().is_in_group("enemy"):
				facing_left = false
				_on_attackarea_area_entered(right.get_collider())
			if not (right.get_collider() is Obstacle):
				return
		elif diry == -1 && up.is_colliding():
			if up.get_collider().is_in_group("enemy"):
				_on_attackarea_area_entered(up.get_collider())
			if not (up.get_collider() is Obstacle):
				return
		elif diry == 1 && down.is_colliding():
			if down.get_collider().is_in_group("enemy"):
				_on_attackarea_area_entered(down.get_collider())
			if not (down.get_collider() is Obstacle):
				return
			
			
		if dirx != 0:
			state = State.WALKING
			var dirgoto = position.x + dirx * tile_size
			if dirx == 1:
				facing_left = false
				spr.play("walk")
			elif dirx == -1:
				facing_left = true
				spr.play("walk_flip")
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
			if facing_left:
				facing_left = true
				spr.play("walk_flip")
			elif !facing_left:
				facing_left = false
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
			music.stream_paused = true
			state = State.ATTACKING
			camera.zoom_in(0.1,Vector2(2,2))
			if facing_left:
				spr.play("attack_flip")
			elif !facing_left:
				spr.play("attack")
			await get_tree().create_timer(0.85).timeout
			hit.play()
			camera.add_trauma(0.2)
			await spr.animation_finished
			Global.attacked.emit(area)
			await get_tree().create_timer(0.85).timeout
			music.stream_paused = false
			var count = get_tree().get_nodes_in_group("enemy").size()
			if Global.enemydead == count:
				Global.level += 1
				Global.enemydead = 0
				await get_tree().create_timer(0.2).timeout
				SceneTransition.change_scene_file()
			state = State.IDLE
			

	elif area is Obstacle:
		while state != State.IDLE:
				await get_tree().physics_frame
		state = State.DEAD
		dead.play()
		camera.add_trauma(0.2)
		music.stop()
		if facing_left:
			spr.play("dead_flip")
		elif !facing_left:
			spr.play("dead")
		await get_tree().create_timer(2).timeout
		Global.enemydead = 0
		SceneTransition.change_scene_file()
		
	
