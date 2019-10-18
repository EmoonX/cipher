extends Node

onready var current = $Corridor
var cont = -60

func _process(delta):
	if cont != 0:
		var value = abs(cont) if cont < 0 else 60 - cont
		$Fade.color.a = value/60.0
		cont -= sign(cont)
	