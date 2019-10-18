extends Spatial

var active = false
var cont = 0

func _on_Area_area_entered(area):
	active = true

func _on_Area_area_exited(area):
	active = false

func _process(delta):
	if active:
		var value = cont/60.0
		if value > 0.5:
			value = 1.0 - value
		value /= 2
		value = 1.0 - value
		$MeshInstance.material_override.albedo_color.b = value
		cont = (cont + 1) % 60
	else:
		cont = 0
		$MeshInstance.material_override.albedo_color = Color(1, 1, 1)