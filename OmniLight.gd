extends OmniLight

var cont = 0

func _process(delta):
	light_energy = 0.5 + cont/480.0
	if light_energy > 0.75:
		light_energy = 1.5 - light_energy
	cont = (cont + 1) % 240
