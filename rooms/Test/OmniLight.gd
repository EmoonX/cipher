extends OmniLight


func _ready():
	while true:
		var tween = Tween.new()
		$"/root/Game/".add_child(tween)
		tween.interpolate_property(self, 
				"light_energy", 0.1, 0.2, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		yield(tween, "tween_completed")
		$"/root/Game/".remove_child(tween)
		var t2 = Tween.new()
		$"/root/Game/".add_child(t2)
		t2.start()
		t2.interpolate_property(self, 
				"light_energy", 0.2, 0.1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		yield(t2, "tween_completed")
		$"/root/Game/".remove_child(t2)
