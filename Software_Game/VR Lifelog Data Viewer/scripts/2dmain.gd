extends Control

@onready var file_open_dialog = $"file open"
@onready var image_display = $ImageDisplay
@onready var video_player = $PlaybackControls/Screen/VideoPlayer
@onready var SBS_Screen2 = $SBS_Screen2 #for images
@onready var SBS_Screen = $SBS_Screen #for videos

var main_path = ""

func _ready():
	pass

func _on_file_open_dialog_open(path: String):	

	SBS_Screen2.hide()	
	SBS_Screen.hide()
	main_path = path
	var window_size = get_viewport_rect().size
	print_debug("Window size is: x="+str(window_size.x)+", y="+str(window_size.y))
	if path.get_extension() == "jpg":
		var image = Image.load_from_file(path)
		var texture = ImageTexture.create_from_image(image)
		print_debug("path is:" + path)
		#var texture = load("res://Sample-JPEG-Image-File-Download-scaled.jpg")
		texture.set_size_override(window_size)
		
		$Disclaimer.hide()
		image_display.texture = texture
		
		image_display.show()
		$Next.show()
		$Previous.show()
		
		# Wait 0.1 seconds then connect the video texture to the surface
		await get_tree().create_timer(0.1).timeout
		SBS_Screen2.get_active_material(0).set_shader_parameter("image", ImageTexture.create_from_image(image))
		SBS_Screen2.show()
		
		
		var json_path = path.replace(".jpg","_prediction.json")
		
		print_debug(".json metadata:" + load_json_data(json_path))
		#var metadata = image.get_data().get_string_from_ascii()
		#print_debug("Metadata:"+metadata)
	elif path.get_extension() == "ogv":
		$PlaybackControls/Screen/VideoPlayer.stream = load(path)
		$PlaybackControls.show()
		$Next.show()
		$Previous.show()
		SBS_Screen.show()

func load_json_data(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open JSON file: " + file_path)
		return {}

	var data_json = file.get_as_text()
	file.close()

	#var json_parser = JSONParseResult()
	

	return data_json

func _on_image_disp_button_pressed():
	image_display.hide()
	SBS_Screen.hide()
	SBS_Screen2.hide()
	$Next.hide()
	$Previous.hide()
	$Disclaimer.show()

func _on_file_open_quit():
	get_tree().quit() # quit game/godot app


func _on_next_pressed():
	print_debug("Current filename is: " + main_path.get_file())
	var current_index = Globals.file_list.find(main_path.get_file())
	print_debug("Current index is: " + str(current_index))
	var next_index = 0
	if (current_index == -1):
		print_debug("File not found! Index error at -1")
	elif (current_index == Globals.file_list.size() - 1):
		# If the current file is the last file, wrap around to the first file
		next_index = 0
	else:
		next_index = current_index + 1
	print_debug("Next index is:" + str(next_index))
	var next_filename = ""
	next_filename = Globals.file_list[next_index]
	print_debug("Previous filename is: " + next_filename)
	var next_path = main_path.get_base_dir() + "/" + next_filename
	print_debug("Previous path is: " + next_path)
	_on_file_open_dialog_open(next_path)
	Globals.play.emit() #autoplay
	


func _on_previous_pressed():
	print_debug("Current filename is: " + main_path.get_file())
	var current_index = Globals.file_list.find(main_path.get_file())
	print_debug("Current index is: " + str(current_index))
	var previous_index = 0
	if (current_index == -1):
		print_debug("File not found! Index error at -1")
	elif (current_index == 0):
		# If the current file is the first file, wrap around to the last file
		previous_index = Globals.file_list.size() - 1
	else:
		previous_index = current_index - 1
	print_debug("Previous index is:" + str(previous_index))
	var previous_filename = ""
	previous_filename = Globals.file_list[previous_index]
	print_debug("Previous filename is: " + previous_filename)
	var previous_path = main_path.get_base_dir() + "/" + previous_filename
	print_debug("Previous path is: " + previous_path)
	_on_file_open_dialog_open(previous_path)
	Globals.play.emit() #autoplay
