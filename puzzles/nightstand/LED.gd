extends OmniLight

# --------------------------------------------------------------------------- #

func _ready():
	$Glow.play("glow")

func change(correct):
	print(correct)
	if correct:
		$Change.play("change")
	else:
		if light_color == ColorN("green"):
			$Change.play_backwards("change")
