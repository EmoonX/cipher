extends TextureRect

# Measuring cup's capacity
export(int) var capacity

# Current amounts (in liters) of oil and water, respectively
export(int) var oil
export(int) var water

const DY = 40

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
