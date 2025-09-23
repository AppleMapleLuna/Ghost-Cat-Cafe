extends Control

signal dialogue_finished

# VARIABLE PLACE YIPPERS
var dialogue_queue: Array = []			# The dialogue is displayed one by one, like a really long shopping line
var current_line: String = ""
var char_index: int = 0
var typing_speed: float = 0.03
var is_typing: bool = false
var typing_id: int = 0


# Background shortcuts
var backgrounds = {
	"default": preload("res://art/Cutscenes/white.png"),
}

# SET Visibility for flexibility in backgrounds
func set_portrait(texture: Texture):
	if texture:
		$CharacterPortrait/Portrait.texture = texture
		$CharacterPortrait.visible = true
	else:
		$CharacterPortrait.visible = false

func set_background(texture: Texture):
	if texture:
		$BackgroundLayer.texture = texture
		$BackgroundLayer.visible = true
	else:
		$BackgroundLayer.visible = false

func set_name_label(text: String):
	$name.text = text
	$name.visible = text != ""

func toggle_speech_box_visibility (visible_yeah: bool):
	$SpeechBox.visible = visible_yeah

func start_dialogue(lines: Array, portrait: Texture = null, background: Texture = null, speaker_name: String = ""):
	reset_dialogue_ui()

	dialogue_queue = lines.duplicate()  # ensure it's a fresh copy
	current_line = ""
	char_index = 0
	is_typing = false
	typing_id += 1  # invalidate any previous typing coroutine

	set_portrait(portrait)
	set_background(background)
	set_name_label(speaker_name)
	show_next_line()

func reset_dialogue_ui():
	$Label.text = ""
	$CharacterPortrait/Portrait.texture = null
	$BackgroundLayer.texture = null
	$name.text = ""
	$SpeechBox.visible = true
	$CharacterPortrait.visible = true
	$BackgroundLayer.visible = true
	$name.visible = true
	show()


func show_next_line():
	if dialogue_queue.is_empty():
		emit_signal("dialogue_finished")
		return

	current_line = dialogue_queue.pop_front()
	char_index = 0
	$Label.text = ""
	is_typing = true
	typing_id += 1	# Invalidate the previous text until you're done typing
	type_next_char()

func type_next_char():
	if current_line == "" or current_line == null:
		print("ERROR: current_line is empty or null")
		is_typing = false
		return

	var current_id = typing_id  # get the id

	if char_index < current_line.length():
		$Label.text += current_line[char_index]
		char_index += 1

		if randi_range(0,1)==0:
			SfxManager.play_click1()
		else:
			SfxManager.play_click2()

		await get_tree().create_timer(typing_speed).timeout

		# Only continue if you're done writing in this id...
		if current_id == typing_id:
			type_next_char()
		else:
			return
	else:
		is_typing = false

func skip_typing():
	typing_id += 1  # Invalidate current typing coroutine
	$Label.text = current_line
	is_typing = false


func _gui_input(event):
	if (event is InputEventMouseButton and event.pressed) or (event is InputEventScreenTouch and event.pressed):
		handle_click()

func handle_click():
	if is_typing:
		skip_typing()
	else:
		show_next_line()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# SKIP EVERYTHING
func _on_texture_button_pressed():
	if is_typing:
		skip_typing()
	else:
		LoadDialogue.skip_all_dialogue()  # assuming DialogueManager is autoloaded as LoadDialogue
