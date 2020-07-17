extends Node

const Card = preload("res://puzzles/tarot/Card.tscn")
const Slot = preload("res://puzzles/tarot/Slot.tscn")

# Number of Major Arcana tarot cards
const NUM_CARDS = 22

# Number of slots to contain cards
const NUM_SLOTS = 5

# Card numbers which must be choosen to win
var solution = [0, 4, 16, 7, 9]

# Content of slots
var slots = []

# --------------------------------------------------------------------------- #

func _ready():
	# Load and position accordingly card images
	for i in range(NUM_CARDS):
		var card = Card.instance()
		var filename = "%02d.jpg" % i
		card.number = i
		card.get_node("Image").texture = \
				load("res://puzzles/tarot/cards/" + filename)
		card.layer = i
		card.offset.x += i * ($Cards.rect_size.x / (NUM_CARDS + 1))
		$Cards.add_child(card)
	
	# Set slots in array
	slots.resize(5)
	for i in range(NUM_SLOTS):
		var slot = Slot.instance()
		$Slots.add_child(slot)
		
	solution.sort()

func _on_Tween_tween_completed(tween):
	remove_child(tween)

func _on_Accept_pressed():
	# Check if slot cards equal solution (in any order)
	var numbers = []
	for card in slots:
		if not card:
			return
		numbers.append(card.number)
	numbers.sort()
	print(numbers)
	print(solution)
	if numbers == solution:
		get_tree().quit()
