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

func change_fluids():
	# Resize water texture
	var water_y = water * DY
	$Water.texture.region.size.y = water_y
	$Water.rect_size.y = water_y
	$Water.rect_position.y = rect_size.y - water_y
	if water:
		# Adjust amount label
		$Water/Amount/Label.visible = true
		$Water/Amount/Label.text = str(water)
		$Water/Amount/Label.rect_position = $Water.rect_global_position + \
				($Water.rect_size / 2) - ($Water/Amount/Label.rect_size / 2)
	else:
		$Water/Amount/Label.visible = false
	
	# Resize and move oil texture
	var oil_y = oil * DY
	$Oil.texture.region.size.y = oil_y
	$Oil.rect_size.y = oil_y
	$Oil.rect_position.y = rect_size.y - (water_y + oil_y)
	if oil:
		# Adjust amount label
		$Oil/Amount/Label.visible = true
		$Oil/Amount/Label.text = str(oil)
		$Oil/Amount/Label.rect_position = $Oil.rect_global_position + \
				($Oil.rect_size / 2) - ($Oil/Amount/Label.rect_size / 2)
	else:
		$Oil/Amount/Label.visible = false

func _draw():
	if selected:
		# Draw circle upon selection
		var color = ColorN("crimson")
		color.a = 0.5
		draw_circle(rect_size / 2, rect_size.x / 2, color)

func _pour_from(cup):
	if oil + water < capacity:
		# Pour oil
		var d_oil = min(cup.oil, capacity - oil - water)
		cup.oil -= d_oil
		oil += d_oil
		if oil + water < capacity:
			# Pour water
			var d_water = min(cup.water, capacity - oil - water)
			cup.water -= d_water
			water += d_water
		
		# Redraw fluids
		cup.change_fluids()
		change_fluids()
		
		# Increment moves counter
		$"../../Moves/Counter".text = \
				str(int($"../../Moves/Counter".text) + 1)

func _on_Cup_gui_input(event):
	if event is InputEventMouseButton and \
			event.pressed and event.button_index == BUTTON_LEFT:
		var action = false
		for cup in $"..".get_children():
			if cup != self and cup.selected:
				# If one was already selected, pour from it
				_pour_from(cup)
				cup.selected = false
				action = true
				break;
		
		if not action:
			# Select/unselect
			selected = not selected
		
		# Draw again
		update()
