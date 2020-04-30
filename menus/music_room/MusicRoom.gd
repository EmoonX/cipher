extends HSplitContainer

const note_image = preload("res://menus/music_room/note.png")

onready var songs = $Container/Songs

var last_idx = -1

# --------------------------------------------------------------------------- #

func _ready():
	# Build list of songs
	for song in songs.get_children():
		if song is VScrollBar:
			continue
		songs.add_item(song.title, note_image, true)
	
	# First of list starts of selected
	songs.select(0)

func _process(_delta):
	# Change info to match currently selected song
	# Need to do it this way as .select() doesn't trigger signals...
	var index = songs.get_selected_items()[0]
	if index != last_idx:
		var title = songs.get_item_text(index)
		var song = songs.get_node(title.capitalize().replace(" ", ""))
		$Container/Info/Composer.text = "Composer: " + song.composer
		$Container/Info/Description.text = song.description
