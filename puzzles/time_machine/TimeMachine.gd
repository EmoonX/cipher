extends Node

# Dictionary of requisited date and time
const datetime = {
	"year": 1984, "month": OS.MONTH_OCTOBER, "day": 31,
	"hour": 16, "minute": 20
}

# --------------------------------------------------------------------------- #

func _ready():
	# Fill label with datetime
	$DateTime.text = "%d-%d-%d %d:%d" % [ \
			datetime["year"], datetime["month"], datetime["day"], 
			datetime["hour"], datetime["minute"] 
	]

func _process(delta):
	if $Button.pressed:
		# Check if system date and clock equals designated datetime
		var current = OS.get_datetime()
		var ok = true
		for key in datetime:
			if current[key] != datetime[key]:
				ok = false
				break
		if ok:
			get_tree().quit()
