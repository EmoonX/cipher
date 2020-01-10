extends Node

const Card = preload("res://puzzles/tarot/Card.tscn")
const Slot = preload("res://puzzles/tarot/Slot.tscn")

# Number of Major Arcana tarot cards
const NUM_CARDS = 22

# Number of slots to contain cards
const NUM_SLOTS = 5

var slots = []

# --------------------------------------------------------------------------- #

func _ready():
	for i in range(NUM_CARDS):
		var card = Card.instance()
		var filename = "%02d.jpg" % i
		card.texture = load("res://puzzles/tarot/cards/" + filename)
		card.rect_position.x = \
				(i+1) * ($Cards.rect_size.x / (NUM_CARDS + 1)) - \
				$Cards.rect_size.x / 2
		$Cards.add_child(card)
	
	slots.resize(5)
	for i in range(NUM_SLOTS):
		var slot = Slot.instance()
		$Slots.add_child(slot)

func _process(delta):
	print($Cards.get_child_count())
