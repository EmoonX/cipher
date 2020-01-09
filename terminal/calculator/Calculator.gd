extends "res://terminal/Program.gd"

const Button = preload("res://terminal/calculator/Button.tscn")

const buttons = "789/456*123-0.=+"

# --------------------------------------------------------------------------- #

func _ready():
	for c in buttons:
		var button = Button.instance()
		button.text = c
		$GUI/Buttons.add_child(button)
