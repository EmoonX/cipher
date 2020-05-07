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

onready var Interactable = get_script()

onready var probe = $"/root/Game".current.get_node("ReflectionProbe")

# List of possible actions to be done with the object
export(Array, ActionType) var actions = []

# What the main character say upon examining
export(String) var examine_text

# In case of being a switch, which node contain lights to be turned on/off
export(NodePath) var linked_lights

var cont = 0.0

# --------------------------------------------------------------------------- #

func _ready():
	# Set up emission "glow" features in materials for when active
	for mesh in get_node("Meshes").get_children():
		for idx in mesh.mesh.get_surface_count():
			var material = mesh.mesh.surface_get_material(idx)
			if not material is SpatialMaterial:
				continue
			material.emission_enabled = true
			material.emission = material.albedo_color
			if material.albedo_texture:
				material.emission_operator = \
						SpatialMaterial.EMISSION_OP_MULTIPLY
				material.emission_texture = material.albedo_texture
			mesh.mesh.surface_set_material(idx, material)

func _update_probe():
	# Update ReflectionProbe when lighting changes
	probe.update_mode = ReflectionProbe.UPDATE_ONCE

func _on_AnimationPlayer_animation_finished(_anim_name):
	_update_probe()

func _process(delta):
	# Set action label text
	var action_label = "ACTION_" + ActionType.keys()[actions[0]]
	action_label = TranslationServer.translate(action_label)
	$ActionLabel.text = action_label
	
	var energy
	if self == $"/root/Game".active_object:
		$ActionLabel.visible = true
		
		energy = abs(cont) / 2
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
					_update_probe()
	
	else:
		$ActionLabel.visible = false
		energy = 0.0
		cont = 0
	
	# Brigthen up object while examining
	for mesh in get_node("Meshes").get_children():
		for idx in mesh.mesh.get_surface_count():
			var material = mesh.mesh.surface_get_material(idx)
			if not material is SpatialMaterial:
				continue
			material.emission_energy = energy
			mesh.mesh.surface_set_material(idx, material)
