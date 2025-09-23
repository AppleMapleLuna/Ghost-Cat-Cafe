extends Node

var dialogue_entries: Array = []
var current_index: int = 0
var dialogue_skipped : bool = false
signal dialogue_sequence_finished

func load_dialogue_from_json(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var raw = file.get_as_text()
		var data = JSON.parse_string(raw)
		if typeof(data) == TYPE_ARRAY:
			dialogue_entries = data
			current_index = 0
			start_next_dialogue()

func start_next_dialogue():
	if dialogue_skipped:
		print("Dialogue was skipped. Ending sequence.")
		return
		
	if current_index >= dialogue_entries.size():
		emit_signal("dialogue_sequence_finished")
		DialogueBox.hide()  # ← hide only after all entries are done
		# Perhaps adding a signal here might be good idk
		return

	var entry = dialogue_entries[current_index]
	current_index += 1
	
	var name_label = entry.get("name", "")
	var portrait_path = entry.get("portrait", null)
	var background_path = entry.get("background", null)
	var lines = entry.get("lines", []).duplicate()
	
	var portrait: Texture = null
	if typeof(portrait_path) == TYPE_STRING and portrait_path != "":
		portrait = load(portrait_path) as Texture

	var background: Texture = null
	if typeof(background_path) == TYPE_STRING and background_path != "":
		background = load(background_path) as Texture

	DialogueBox.start_dialogue(lines, portrait, background, name_label)
	await DialogueBox.dialogue_finished
	start_next_dialogue()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func skip_all_dialogue():
	if dialogue_skipped:
		return
	dialogue_skipped = true
	force_end_dialogue()

func force_end_dialogue():
	current_index = dialogue_entries.size()
	DialogueBox.emit_signal("dialogue_finished")
	DialogueBox.is_typing = false
	emit_signal("dialogue_sequence_finished")
	DialogueBox.hide()

