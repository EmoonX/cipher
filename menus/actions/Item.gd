extends Button

# Initial y coordinate, based on node order among siblings
var y_ini

# --------------------------------------------------------------------------- #

func _ready():
	update()
	
func update():
	# Set localized action text
	var s = "ACTION_" + name.to_upper()
	text = TranslationServer.translate(s)
	
	# Set action icon
	var path = "res://menus/actions/icons/" + name.to_lower() + ".png"
	icon = load(path)
	
	# Calculate initial y coordinate
	var offset = rect_size.y + $"..".get("custom_constants/separation")
	y_ini = get_index() * offset

func _process(_delta):
	# Position button correctly upon animation
	#rect_position.x = 200 * (1 - rect_scale.x)
	rect_position.y = y_ini + 18 * (1 - rect_scale.y)
