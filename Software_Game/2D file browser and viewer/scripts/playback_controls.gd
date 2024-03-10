extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# In playback_controls.tscn script
func playButtonPressed():
	# Emit a custom signal or call a method in the main scene to play the video.
	# You can emit a signal like this:
	Globals.play.emit()

func stopButtonPressed():
	# Emit a custom signal or call a method in the main scene to stop the video.
	# You can emit a signal like this:
	Globals.stop.emit()
	
func pauseButtonPressed():
	# Emit a custom signal or call a method in the main scene to stop the video.
	# You can emit a signal like this:
	Globals.pause.emit()
