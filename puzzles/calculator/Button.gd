extends Button

onready var puzzle = $"../../.."

# --------------------------------------------------------------------------- #

func _on_Button_pressed():
	var s = $"../../Display".text
	var number = int(s)
	
	match text:
		"+", "−", "×", "/", "=":
			if not puzzle.current_operation:
				# First number entered
				puzzle.total = number
			elif not puzzle.clear_next:
				# Do respective operation
				match puzzle.current_operation:
					"+":
						puzzle.total += number
					"−":
						puzzle.total -= number
					"×":
						puzzle.total *= number
					"/":
						puzzle.total /= number
				
				# Display current result
				number = puzzle.total
			
			# Register button operation
			puzzle.current_operation = text
			
			# Mark that next number should clear display first
			puzzle.clear_next = true
			
			if text == "=":
				# Clear operations on "=" button
				puzzle.total = 0
				puzzle.current_operation = null
		
		"CE":
			# Clear everything
			number = 0
			puzzle.total = 0
		
		_:
			if puzzle.clear_next:
				# Clear display if last was an operation
				number = 0
				puzzle.clear_next = false
				
			# Append digit to number, if space is left
			if str(number).length() < $"../../Display".max_length:
				number = 10 * number + int(text)
	
	$"../../Display".text = str(number)
