extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the finished event
	$VideoPlayer.finished.connect(_on_finished)

	# Start playing
	$VideoPlayer.play()

	# Wait 0.1 seconds then connect the video texture to the surface
	await get_tree().create_timer(0.1).timeout
	#get_active_material(0).set_shader_parameter("movie", $VideoStreamPlayer.get_video_texture())
	
	
	Globals.play.connect(_on_play_video)
	Globals.stop.connect(_on_stop_video)
	Globals.pause.connect(_on_pause_video)
	pass
	
func _on_play_video():
	#$VideoPlayer.stream = load("E:/OneDrive - University of Southampton/COURSES/Y3/COMP3200 Individual Project/Software_Processing/Combined-pipeline/Samples-testing-8-march/output/videos/test.ogv")  # Replace with your video file path
	$VideoPlayer.show()
	self.show()
	$VideoPlayer.play()
	
	# Wait 0.1 seconds then connect the video texture to the surface
	await get_tree().create_timer(0.1).timeout
	#get_active_material(0).set_shader_parameter("movie", $VideoStreamPlayer.get_video_texture())

func _on_stop_video():
	$VideoPlayer.stop()
	$VideoPlayer.hide()
	self.hide()
	get_node("%PlaybackControls").hide()
	
func _on_pause_video():
	# alternate true or false for every button press
	if ($VideoPlayer.paused == true):
		$VideoPlayer.paused = false
	else:
		$VideoPlayer.paused = true
	
func _on_finished() -> void:
	$VideoPlayer.play()
