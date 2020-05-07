extends "res://objects/Interactable.gd"

onready var player = $"/root/Game/Player"
onready var rotation_helper = player.get_node("RotationHelper")

# The paths to the mesh instances that will use the glass material
export(Array, NodePath) var mesh_paths

# --------------------------------------------------------------------------- #

func _ready():
	# Set viewport texture to the shader material the hard way
	# (or else it won't work...)
	var viewport_texture = $Viewport.get_texture()
	for path in mesh_paths:
		var node = get_node(path)
		var mesh = node.mesh
		var material = mesh.surface_get_material(0)
		material.set("shader_param/viewport_texture", viewport_texture)
		mesh.surface_set_material(0, material)
		node.mesh = mesh.duplicate()
	
func _process(_delta):
	var offset = rotation_helper.rotation_degrees
	offset.x *= -1
	var rot = player.rotation_degrees + offset + Vector3(0, 180, 0)
	$Viewport/Camera.rotation_degrees = rot
