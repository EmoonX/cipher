extends TextureRect

const DY = 40

# Measuring cup's capacity
export(int) var capacity

# Current amounts (in liters) of oil and water, respectively
export(int) var oil
export(int) var water

# If cup is currently selected
var selected = false

# --------------------------------------------------------------------------- #

func _ready():
	# Resize cup according to capacity
	margin_top = -(capacity * DY)
	
	# Resize water texture
	var water_y = water * DY
	$Water.texture.region.size.y = water_y
	$Water.rect_size.y = water_y
	$Water.rect_position.y = rect_size.y - water_y
	
	# Resize and move oil texture
	var oil_y = oil * DY
	$Oil.texture.region.size.y = oil_y
	$Oil.rect_size.y = oil_y
	$Oil.rect_position.y = rect_size.y - (water_y + oil_y)

func _draw():
	if selected:
		# Draw circle upon selection
		var color = ColorN("crimson")
		color.a = 0.5
		draw_circle(rect_size / 2, rect_size.x / 2, color)

func _on_Cup_gui_input(event):
	if event is InputEventMouseButton and \
			event.pressed and event.button_index == BUTTON_LEFT:
		var action = false
		for cup in $"..".get_children():
			if cup != self and cup.selected:
				action = true
				break;
		if not action:
			# Select/unselect
			selected = not selected
			update()
