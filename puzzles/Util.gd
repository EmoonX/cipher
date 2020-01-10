extends Node

# --------------------------------------------------------------------------- #

func move(node, property, value):
	# Move card to new_off position with a tween effect
	var tween = Tween.new()
	tween.interpolate_property(node,
			property, null, value, 0.5,
			Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()
	$"/root".get_child(0).add_child(tween)