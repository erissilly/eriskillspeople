extends CanvasLayer


@onready var tsound_dead: AudioStreamPlayer = $transition_sound_dead
@onready var tsound: AudioStreamPlayer = $transition_sound
@onready var transition_color: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var tp := false

func change_scene_file() -> void:
	tp = true
	if Global.player != null and Global.player.state == Global.player.State.DEAD:
		transition_color.material.set_shader_parameter("color", Color("582727ff"))
		tsound_dead.play()
	else:
		transition_color.material.set_shader_parameter("color", Color("#000000"))
		tsound.play()
	animation_player.play("dissolve")
	await animation_player.animation_finished
	get_tree().call_group("enemy", "queue_free")
	get_tree().reload_current_scene()
	animation_player.play_backwards("dissolve")
	tp = false

func start_scene(scene: String) -> void:
	tp = true
	transition_color.material.set_shader_parameter("color", Color("#000000"))
	tsound.play()
	animation_player.play("dissolve")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene)
	animation_player.play_backwards("dissolve")
	tp = false
