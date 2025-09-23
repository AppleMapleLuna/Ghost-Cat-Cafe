extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$ToasterPlayer.visible = false
	$ToasterPlayer.can_move= false
	$bg.visible = false
	LoadDialogue.connect("dialogue_sequence_finished", Callable(self, "_on_load_dialogue_dialogue_sequence_finished"))
	LoadDialogue.load_dialogue_from_json("res://scripts/dialogue/intro.json")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_load_dialogue_dialogue_sequence_finished():
	$ToasterPlayer.visible = true
	$bg.visible = true
	await get_tree().create_timer(0.5).timeout  # Delay before enabling input
	$ToasterPlayer.can_move= true
