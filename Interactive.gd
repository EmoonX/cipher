extends Spatial

var active = false

func _on_Area_area_entered(area):
	active = true

func _on_Area_area_exited(area):
	active = false
