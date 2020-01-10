extends TextureRect

onready var slots = $"../..".slots

# Original position in card deck
onready var original_pos = rect_position

# Slot index that the cards is in, or -1 if none
var slot_id = -1

# --------------------------------------------------------------------------- #

func _on_Card_focus_entered():
	if slot_id == -1:
		# Remove card from deck and put it in a empty slot
		for i in range(len(slots)):
			if not slots[i]:
				slots[i] = self
				slot_id = i
				var slot = $"../../Slots".get_child(i)
				get_parent().remove_child(self)
				slot.add_child(self)
				rect_position = Vector2(0, 0)
				break
	else:
		# Remove card from slot and put back into deck
		slots[slot_id] = null
		slot_id = -1
		$"../../../Cards".add_child(duplicate())
		get_parent().remove_child(self)
		rect_position = original_pos
