extends Control

# --------------------------------------------------------------------------- #

func _ready():
	# Create player configuration file (if it doesn't exist)
	var file = File.new()
	if not file.file_exists("player.cfg"):
		var dir = Directory.new()
		var err = dir.copy("res://etc/base.cfg", "player.cfg")

func _process(delta):
	if $Fade.color.a > 0.0:
		var value = $Fade.color.a - delta
		$Fade.color.a = max(value, 0.0)
		if $Fade.color.a == 0.0:
			$Fade.visible = false
			$Items/Start.grab_focus()
	
	if $Items/Start.pressed:
		get_tree().change_scene("res://Game.tscn")
	elif $Items/Options.pressed:
		get_tree().change_scene("res://menus/Options.tscn")
	elif $Items/Quit.pressed:
		get_tree().quit()
