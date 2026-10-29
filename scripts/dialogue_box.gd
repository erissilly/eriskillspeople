extends CanvasLayer

signal dialog_end
signal line_started(id)

@export_file("*.json") var d_file : String = "res://json/dialogue.json"
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var namelabel: RichTextLabel = $NinePatchRect/Name
@onready var textlabel: RichTextLabel = $NinePatchRect/MarginContainer/Text
@onready var timer: Timer = $Timer
@export var char_delay := 0.05
@onready var nose: AnimatedSprite2D = $NinePatchRect/nose
@export var anchor: Control.LayoutPreset = Control.PRESET_CENTER_BOTTOM

var startline_id := 0
var dialogue = {}
var active = false
var is_typing = false

var pause_times := {",": 0.2, ".": 0.35, "!":0.3,	"?":0.3, " ": 0.06}

func _ready() -> void:
	nine_patch_rect.set_anchors_and_offsets_preset(anchor,  Control.PRESET_MODE_KEEP_SIZE)
	nose.hide()
	textlabel.visible_characters = 0
	nine_patch_rect.hide()
	nine_patch_rect.modulate.a = 0
	await get_tree().create_timer(1).timeout
	var tweenthing = get_tree().create_tween()
	nine_patch_rect.show()
	tweenthing.tween_property(nine_patch_rect, "modulate:a", 1, 0.3)
	start_dialog()

func start_dialog():
	dialogue = load_dialogue()
	startline_id = -1
	active = true
	next_script()


func load_dialogue():
	var file = FileAccess.open(d_file, FileAccess.READ)
	if file:
		return JSON.parse_string(file.get_as_text())
	return{}

func _input(event: InputEvent) -> void:
	if not active:
		return
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			is_typing=false
			textlabel.visible_characters = -1
			nose.show()
		else:
			next_script()
			
func next_script():
	startline_id += 1
	
	if startline_id >= len(dialogue):
		timer.start()
		active = false
		nine_patch_rect.hide()
		dialog_end.emit()
		return
	nose.hide()
	namelabel.text = dialogue[startline_id]["name"]
	textlabel.text = dialogue[startline_id]["text"]
	line_started.emit(startline_id)
	type_line()
	
	
func type_line():
	is_typing= true
	textlabel.visible_characters = 0

	for letter in textlabel.text:
		if not is_typing:
			return
		textlabel.visible_characters += 1
		var wait = pause_times.get(letter, char_delay)
		await get_tree().create_timer(wait).timeout
	is_typing = false
	nose.show()


func _on_timer_timeout() -> void:
	active = false
