extends "res://puzzles/Puzzle.gd"

# --------------------------------------------------------------------------- #

class CustomSorter:
	static func sort_by_x(a: CanvasLayer, b: CanvasLayer):
		# Sort pieces based on global x coordinate
		var x1 = a.offset.x + a.get_node("Image").rect_position.x
		var x2 = b.offset.x + b.get_node("Image").rect_position.x
		return x1 < x2

func _draw():
	# Get sorted list of soldiers
	var soldiers = get_children()
	soldiers.sort_custom(CustomSorter, "sort_by_x")
	
	# Iterate through all soldiers
	var count = 0
	for i in range(len(soldiers)):
		var soldier = soldiers[i]
		var size = soldier.get_node("Image").rect_size
		var pos1 = soldier.offset + soldier.get_node("Image").rect_position
		pos1 += size / 2
		
		# Soldiers to the right of selected one
		var used = []
		for j in range(i+1, len(soldiers)):
			var other = soldiers[j]
			var pos2 = other.offset + other.get_node("Image").rect_position
			pos2 += size / 2
			
			# Calculate initial angle
			var dx = pos2.x - pos1.x
			var dy = pos2.y - pos1.y
			var alpha = atan2(dy, dx)
			
			# Build list of collinear soliders
			var line = [soldier]
			for k in range(j, len(soldiers)):
				var another = soldiers[k]
				if another in used:
					# Ignore soldiers from already formed lines
					continue
				pos2 = another.offset + another.get_node("Image").rect_position
				pos2 += size / 2
				
				# Calculate angle
				dx = pos2.x - pos1.x
				dy = pos2.y - pos1.y
				var beta = atan2(dy, dx)
				
				# If diff between angles is below a certain threshold, then OK
				if abs(beta - alpha) < 0.05:
					line.append(another)
					if len(line) == 4:
						break
			
			if len(line) == 4:
				# If line is formed, draw lines between soldiers in sequence
				count += 1
				for l in range(3):
					var pos3 = line[l].offset + \
							line[l].get_node("Image").rect_position
					pos3 += size / 2
					var pos4 = line[l+1].offset + \
							line[l+1].get_node("Image").rect_position
					pos4 += size / 2
					draw_line(pos3, pos4, ColorN("crimson"), 5.0)
					used.append(line[l+1])
	
	if count == 5:
		# If all lines are formed, you win!
		get_tree().quit()

func _process(delta):
	update()
