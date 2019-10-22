extends Spatial

# What to show when interacting with
export(String) var action_text

var active = false
var cont = 0

# --------------------------------------------------------------------------- #

func _ready():
	$ActionText.text = action_text

func _process(delta):
	if active:
		var value = cont/60.0
		if value > 0.5:
			value = 1.0 - value
		value /= 2
		value = 1.0 - value
		$MeshInstance.material_override.albedo_color.b = value
		$ActionText.visible = true
		cont = (cont + 1) % 60
	else:
		$MeshInstance.material_override.albedo_color = Color(1, 1, 1)
		$ActionText.visible = false
		cont = 0

func _on_Area_area_entered(area):
	active = true

func _on_Area_area_exited(area):
	active = false
