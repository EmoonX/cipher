extends Spatial

# --------------------------------------------------------------------------- #

func _ready():
	set_process(false)

func _on_Puzzle_visibility_changed():
	if visible:
		$Camera.current = true
	set_process(visible)

func _process(_delta):
	pass
