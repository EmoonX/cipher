extends Button

onready var display = $"../../Display"

# --------------------------------------------------------------------------- #

func _on_Button_pressed():
	var result = float(display.text)
	match text:
		"+", "-", "*" "/":
			
		"."
		
		"="
		
		_:
			# Digit entered
			if len(display.text) < 8:
				result = 10 * result + int(text)
	
	# Update display number
	display.text = str(result)
