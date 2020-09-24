extends "res://puzzles/Puzzle.gd"

# --------------------------------------------------------------------------- #

class CustomSorter:
	static func sort_by_x(a: CanvasLayer, b: CanvasLayer):
		var x1 = a.offset.x + a.get_node("Image").rect_position.x
		var x2 = b.offset.x + b.get_node("Image").rect_position.x
		return x1 < x2

func _draw():
	var pairs = []
	var soldiers = get_children()
	soldiers.sort_custom(CustomSorter, "sort_by_x")
	for i in range(len(soldiers)):
		var soldier = soldiers[i]
		var size = soldier.get_node("Image").rect_size
		var pos1 = soldier.offset + soldier.get_node("Image").rect_position
		pos1 += size / 2
		for j in range(i+1, len(soldiers)):
			var other = soldiers[j]
#			if [soldier, other] in pairs or [other, soldier] in pairs:
#				continue
			var pos2 = other.offset + other.get_node("Image").rect_position
			pos2 += size / 2
			
			var dx = pos2.x - pos1.x
			var dy = pos2.y - pos1.y
			var alpha = atan2(dy, dx)
			var line = [soldier]
			for k in range(j, len(soldiers)):
				var another = soldiers[k]
#				if [soldier, another] in pairs or [another, soldier] in pairs:
#					continue
				pos2 = another.offset + another.get_node("Image").rect_position
				pos2 += size / 2
				
				dx = pos2.x - pos1.x
				dy = pos2.y - pos1.y
				var beta = atan2(dy, dx)
				if abs(beta - alpha) < 0.04:
					line.append(another)
			
			#print(line)
			if len(line) == 4:
				for l in range(3):
					var pos3 = line[l].offset + \
							line[l].get_node("Image").rect_position
					pos3 += size / 2
					var pos4 = line[l+1].offset + \
							line[l+1].get_node("Image").rect_position
					pos4 += size / 2
					draw_line(pos3, pos4, ColorN("crimson"), 5.0)
					pairs.append([line[l], line[l+1]])

func _process(delta):
	update()
