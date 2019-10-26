extends Spatial

# Text to show when interacting with
export(String) var action_label

# What the main character say upon examining
export(String) var flavor_text

# If the object is in player's action range
var active = false

var cont = 0

# --------------------------------------------------------------------------- #

func _ready():
	$ActionLabel.text = action_label

func _process(delta):
	if active:
		var value = cont/60.0
		if value > 0.5:
			value = 1.0 - value
		value /= 2
		value = 1.0 - value
		#$MeshInstance.material_override.albedo_color.b = value
		$ActionLabel.visible = true
		cont = (cont + 1) % 60
		
		if Input.is_action_just_pressed("action") and flavor_text:
			$"/root/Game".display_subtitles(flavor_text)
	else:
		#$MeshInstance.material_override.albedo_color = Color(1, 1, 1)
		$ActionLabel.visible = false
		cont = 0

func _on_Area_area_entered(area):
	active = true

func _on_Area_area_exited(area):
	active = false
