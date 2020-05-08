extends VBoxContainer

# Initial position x of container
onready var x_ini = rect_position.x

# --------------------------------------------------------------------------- #

func _process(delta):
	# Position node correctly on screen
	var offset = OS.window_size.x - OS.window_size.y * 16.0/9.0
	offset = max(0, offset)
	rect_position.x = x_ini + (offset * (1080 / OS.window_size.y) / 2)
