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
	
	# Put focus on song list and select first song of it
	songs.grab_focus()
	songs.select(0)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		# Return to main menu
		get_tree().change_scene("res://menus/MainMenu.tscn")
	
	# Get node corresponding to currently selected song
	var index = songs.get_selected_items()[0]
	var title = songs.get_item_text(index)
	var song = songs.get_node(title.capitalize().replace(" ", ""))
	
	# Change info to match song
	# (need to be done this way as .select() doesn't trigger signals...)
	if index != last_idx:
		var s = TranslationServer.translate("MUSIC_COMPOSER")
		$Container/Info/Composer.text = s + ": " + song.composer
		$Container/Info/Description.text = song.description
		last_idx = index
	
	if Input.is_action_just_pressed("ui_accept"):
		if not song.playing:
			# Play respective music file
			var filename = title.to_lower().replace(" ", "_") + ".ogg"
			var path = "res://audio/bgm/" + filename
			BGM.stream = load(path)
			BGM.play()
			song.playing = true
		else:
			# Stop playback
			BGM.stop()
			song.playing = false
