extends Control

const Puzzle = preload("res://puzzles/Puzzle.gd")
const PuzzleItem = preload("PuzzleItem.tscn")

# --------------------------------------------------------------------------- #

func _ready():
	var root = Directory.new()
	root.change_dir("res://puzzles/")
	root.list_dir_begin()
	while true:
		var path = root.get_next()
		if not path:
			break
		if root.dir_exists(path):
			var dir = Directory.new()
			path = "res://puzzles/" + path
			dir.change_dir(path)
			dir.list_dir_begin()
			while true:
				var file = dir.get_next()
				if not file:
					break
				file = path + "/" + file
				var scene = load(file)
				if not scene is PackedScene:
					continue
				var puzzle = scene.instance()
				if puzzle is Puzzle and puzzle.title:
					print(puzzle)
					_add_puzzle(puzzle)

func _add_puzzle(puzzle):
	var item = PuzzleItem.instance()
	item.get_node("Container/Number").text = "001"
	item.get_node("Container/Title").text = puzzle.title
	$Roster/Container.add_child(item)
