extends Button

onready var y_ini = rect_position.y - 18

# --------------------------------------------------------------------------- #

func _process(_delta):
	#rect_position.x = 200 * (1 - rect_scale.x)
	rect_position.y = y_ini + 18 * (1 - rect_scale.y)
