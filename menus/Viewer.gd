extends Control

# If mouse is hovering the viewer
var hover = false

# Initial click offset
var offset = null

# --------------------------------------------------------------------------- #

func _on_Viewer_mouse_entered():
	hover = true
	
func _on_Viewer_mouse_exited():
	hover = false

func _input(event):
	if hover:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			if event is InputEventMouseButton and event.doubleclick:
				offset = null
				
				# Smoothly go back to starting position
				var tween = Tween.new()
				add_child(tween)
				tween.interpolate_property($"../../Viewport/Item",
						"rotation_degrees", null, Vector3(0, 0, 0), 0.2,
						Tween.TRANS_LINEAR, Tween.EASE_OUT)
				tween.start()
				yield(tween, "tween_completed")
				remove_child(tween)
				
				# Restart animation
				$"../../Viewport/AnimationPlayer".play()
			
			else:
				# Stop animation
				$"../../Viewport/AnimationPlayer".stop()
				
				# Update rotation based on motion relative to initial click
				if not offset:
					offset = event.position
				$"../../Viewport/Item".rotation_degrees.x += \
						(event.position.y - offset.y) / 2
				$"../../Viewport/Item".rotation_degrees.y += \
						(event.position.x - offset.x) / 2
				offset = event.position
		
		else:
			offset = null
