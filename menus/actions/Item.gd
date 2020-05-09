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

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "show" and get_index() == 0:
		# Focus on first item of list after animating it in
		grab_focus()

func _on_Item_focus_entered():
	# Mark current action as selected:
	var object = $"../../.."
	object.selected_action = object.actions[get_index()]
	
	# Play selection animation loop until getting out of focus
	while has_focus():
		$AnimationPlayer.play("focus")
		yield($AnimationPlayer, "animation_finished")
	
func _on_Item_focus_exited():
	# Return (in the quickest way possible) to non selected state
	var pos = $AnimationPlayer.current_animation_position
	var length = $AnimationPlayer.current_animation_length
	var speed = -2.0 if pos < length/2 else 2.0
	$AnimationPlayer.play("focus", 0, speed, true)

func _process(_delta):
	# Position button correctly upon animation
	if $AnimationPlayer.current_animation == "focus":
		rect_position.x = 200 * (1 - rect_scale.x)
	rect_position.y = y_ini + 18 * (1 - rect_scale.y)
