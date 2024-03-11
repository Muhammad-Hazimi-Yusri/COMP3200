extends Control

@onready var file_open_dialog = $"file open"
@onready var image_display = $ImageDisplay
@onready var video_player = $PlaybackControls/Screen/VideoPlayer

func _ready():
	pass

func _on_file_open_dialog_open(path: String):
	var window_size = get_viewport_rect().size
	print_debug("Window size is: x="+str(window_size.x)+", y="+str(window_size.y))
	if path.get_extension() == "jpg":
		var image = Image.load_from_file(path)
		var texture = ImageTexture.create_from_image(image)
		print_debug("path is:" + path)
		#var texture = load("res://Sample-JPEG-Image-File-Download-scaled.jpg")
		texture.set_size_override(window_size)
		
		image_display.texture = texture
		image_display.show()
		
		
		var json_path = path.replace(".jpg","_predictions.json")
		
		print_debug(".json metadata:" + str(load_json_data(json_path)))
		#var metadata = image.get_data().get_string_from_ascii()
		#print_debug("Metadata:"+metadata)
	elif path.get_extension() == "ogv":
		$PlaybackControls/Screen/VideoPlayer.stream = load(path)
		$PlaybackControls.show()
		pass

func load_json_data(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open JSON file: " + file_path)
		return {}

	var data_json = file.get_as_text()
	file.close()

	#var json_parser = JSONParseResult()
	var data = JSON.parse_string(data_json)

	if data.error != OK:
		push_error("Error parsing JSON file: " + data.error_string)
		return {}

	if typeof(data) != TYPE_DICTIONARY:
		push_error("JSON data is not a dictionary")
		return {}

	return data

func _on_image_disp_button_pressed():
	image_display.hide()

func _on_file_open_quit():
	get_tree().quit() # quit game/godot app

