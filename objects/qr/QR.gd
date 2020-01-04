extends "res://objects/Interactable.gd"

export(String) var image
export(String) var file

# --------------------------------------------------------------------------- #

func _ready():
	image = "res://objects/qr/" + image
	$MeshInstance.material_override = \
			$MeshInstance.material_override.duplicate(true)
	$MeshInstance.material_override.albedo_texture = load(image)

func _process(delta):
	if active and Input.is_action_just_pressed("action"):
		var filename = "res://objects/qr/" + file
		var dir = Directory.new()
		dir.copy(filename, "res://user/files/doc/" + file)
