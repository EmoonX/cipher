extends "res://Interactable.gd"

export(String, FILE, "*.png") var image
export(String, FILE) var file

# --------------------------------------------------------------------------- #

func _ready():
	$MeshInstance.material_override = \
			$MeshInstance.material_override.duplicate(true)
	$MeshInstance.material_override.albedo_texture = load(image)
