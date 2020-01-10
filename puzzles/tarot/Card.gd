extends CanvasLayer

onready var slots = $"../..".slots

# Number of card in Major Arcana
var number

# Original position in card deck
var original_pos

# Slot index that the cards is in, or -1 if none
var slot_id = -1

# --------------------------------------------------------------------------- #

func _on_Image_focus_entered():
	if slot_id == -1:
		# Remove card from deck and put it in a empty slot
		original_pos = offset
		for i in range(len(slots)):
			if not slots[i]:
				slots[i] = self
				slot_id = i
				var slot = $"../../Slots".get_child(i)
				var new_off = $"../../Slots".rect_position + slot.rect_position
				Util.move(self, "offset", new_off)
				get_parent().remove_child(self)
				slot.add_child(self)
				break
	else:
		# Remove card from slot and put back into deck
		slots[slot_id] = null
		slot_id = -1
		var new = duplicate()
		$"../../../Cards".add_child(new)
		get_parent().remove_child(self)
		Util.move(new, "offset", original_pos)
