extends "res://Interactable.gd"

export(String, FILE, "*.png") var image
export(String, FILE) var file

# --------------------------------------------------------------------------- #

func _ready():
	$MeshInstance.material_override = \
			$MeshInstance.material_override.duplicate(true)
	$MeshInstance.material_override.albedo_texture = load(image)

func _process(delta):
	if active and Input.is_action_just_pressed("action"):
		var name = file.split("/")[-1]
		var files = $"/root/Game/Terminal".files
		if not name in files:
			files.append(name)
