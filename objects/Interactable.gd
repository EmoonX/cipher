extends Spatial

# Text to show when interacting with
export(String) var action_label

# What the main character say upon examining
export(String) var examine_text

# If the object is in player's action range
var active = false

var cont = 0.0

# --------------------------------------------------------------------------- #

func _ready():
	$ActionLabel.text = action_label

func _on_Area_area_entered(area):
	active = true

func _on_Area_area_exited(area):
	active = false

func _process(delta):
	var energy
	if active:
		$ActionLabel.visible = true
		
		energy = abs(cont) / 32
		cont -= delta * 2
		if cont < -1.0:
			cont = 1.0
		
		if Input.is_action_just_pressed("action") and examine_text:
			$"/root/Game".display_subtitles(examine_text)
	else:
		$ActionLabel.visible = false
		energy = 0.0
		cont = 0
	
	# Brigthen up object while examining
	for mesh in get_node("Meshes").get_children():
		var material = mesh.mesh.get("surface_1/material")
		if not material:
			continue
		material.emission_enabled = true
		material.emission = ColorN("white")
		material.emission_energy = energy
		mesh.mesh.set("surface_1/material", material)
