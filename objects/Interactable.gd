extends Spatial

enum ActionType {
	EXAMINE
	OPEN_DOOR
	TURN_ON
	TURN_OFF
	OPEN
	CLOSE
	PICK_UP
	SCAN
}

# List of possible actions to be done with the object
export(Array, ActionType) var actions = []

# What the main character say upon examining
export(String) var examine_text

# In case of being a switch, which node contain lights to be turned on/off
export(NodePath) var linked_lights

# If the object is in player's action range
var active = false

var cont = 0.0

# --------------------------------------------------------------------------- #

func _on_Area_area_entered(area):
	active = true

func _on_Area_area_exited(area):
	active = false

func _process(delta):
	# Set action label text
	var action_label = "ACTION_" + ActionType.keys()[actions[0]]
	action_label = TranslationServer.translate(action_label)
	$ActionLabel.text = action_label
	
	var energy
	if active:
		$ActionLabel.visible = true
		
		energy = abs(cont) / 32
		cont -= delta * 2
		if cont < -1.0:
			cont = 1.0
		
		if Input.is_action_just_pressed("action"):
			match actions[0]:
				ActionType.EXAMINE:
					# Examine (get player flavored info from) the object
					$"/root/Game".display_subtitles(examine_text)
					
				ActionType.OPEN:
					# Open a curtain, closet, etc
					$AnimationPlayer.current_animation = "open"
					$AnimationPlayer.play()
					actions[0] = ActionType.CLOSE
				ActionType.CLOSE:
					# Close a curtain, closet, etc
					$AnimationPlayer.current_animation = "close"
					$AnimationPlayer.play()
					actions[0] = ActionType.OPEN
					
				ActionType.TURN_ON, ActionType.TURN_OFF:
					# Turn on or off a light source
					var lights = get_node(linked_lights)
					lights.visible = not lights.visible
					if actions[0] == ActionType.TURN_ON:
						actions[0] = ActionType.TURN_OFF
					else:
						actions[0] = ActionType.TURN_ON
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
