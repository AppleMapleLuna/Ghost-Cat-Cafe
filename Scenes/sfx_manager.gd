extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_meow():
	$catMeowSound.play()

func play_vine_boom():
	$VineBoomSound.play()

func play_click1():
	$Click1.play()
	
func play_click2():
	$Click2.play()

func play_Orchestra():
	$OrchestraHitSound.play()

func play_GameOverSound():
	$GameOverSound.play()

func play_Bump():
	$BumpSound.play()
