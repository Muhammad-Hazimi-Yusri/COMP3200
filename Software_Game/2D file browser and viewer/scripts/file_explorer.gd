extends ColorRect

@onready var cont = $ScrollContainer/GridContainer
@onready var pinned = $pinned/pinned_container
@onready var Npath = $path

# Add this variable to store the selected filter index
var selected_filter_index = 0

var path:String = ""
var file:bool = false

var limited = []

signal done(path:String)

# Called when the node enters the scene tree for the first time.
func _ready():    
	#path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	# use the output combine-pipeline folder as path for now!
	path = "E:/OneDrive - University of Southampton/COURSES/Y3/COMP3200 Individual Project/Software_Processing/Combined-pipeline/Year2024"
	set_layout()
	for i in Globals.pinned:
		add_pinned_button(i)
		
	
func add_pinned_button(arr:Array):
	var nBut = Button.new()
	nBut.text = arr[0]
	pinned.add_child(nBut)
	nBut.pressed.connect(to_dir.bind(arr[1]))
	
func to_dir(new_path:String):
	path = new_path
	set_layout()

func open_folder(folder_name:String):
	if file:
		path = path.get_base_dir()
	path = path + "/" + folder_name
	print_debug("Folder opened!")
	set_layout()
	
func open_file(file_name:String):
	if file:
		path = path.get_base_dir()
	#path = path + "/" + file_name # commented and modifief line below as fix for crash from recalling videoplayer.load at wrong path again for some reason at line 88
	Npath.text = path + "/" + file_name
	file = true
	
func set_layout(search_text: String ="", repopulate_dropdown: bool = false):
	file = false
	Npath.text = path
	for i in cont.get_children(): i.queue_free()
	
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	# Get the selected filter option
	var selected_filter = $metadata_filters.get_item_text(selected_filter_index)
	print_debug("Selected filter is:"+selected_filter)
	
	while file_name != "":
		if search_text == "" or file_name.contains(search_text):
			if dir.current_is_dir():
				var nBut = Button.new()
				nBut.text = file_name
				cont.add_child(nBut)
				nBut.pressed.connect(open_folder.bind(file_name))
				nBut.add_theme_stylebox_override("normal", load("res://folder_box.tres"))
			else:
				var file_extension = file_name.get_extension()
				if file_extension in limited:
					print_debug("File extension is: " + file_extension)
					if file_extension == "jpg":
						var file_json = path + "/" + file_name.get_basename() + "_prediction.json"
						print_debug(file_json)
						#FileAccess.file_exists(file_json):
						var predictions = read_metadata_file(file_json)
						if selected_filter == "no filter" or selected_filter in predictions.keys():
							print_debug("displaying files")
							display_file(file_name, file_extension, cont)
						else:
							print_debug(predictions.keys())
					elif file_extension == "ogv":
						var base_name = file_name.get_basename()
						var json_files = []
						for i in range(0, 5):
							var json_file = path + "/" + base_name + "_prediction" + str(i * 180) + ".json" #need to change the metadata frame to be in 0,180,360,540,720 etc
							if FileAccess.file_exists(json_file):
								json_files.append(json_file)
						if json_files:
							var predictions = {}
							for json_file in json_files:
								predictions.merge(read_metadata_file(json_file), true)
							if selected_filter == "no filter" or selected_filter in predictions.keys():
								print_debug("displaying files")
								display_file(file_name, file_extension, cont)
							else:
								print_debug(predictions.keys())
		file_name = dir.get_next()

	# Update dropdown with filters
	var metadata_counts = {}
	if repopulate_dropdown == true:
		for file in dir.get_files():
			if file.ends_with("_analysis.txt"):
				var file_metadata_counts = read_metadata_analysis(path + "/" + file)
				for label in file_metadata_counts.keys():
					if label in metadata_counts:
						metadata_counts[label] += file_metadata_counts[label]
					else:
						metadata_counts[label] = file_metadata_counts[label]
		
	if repopulate_dropdown == true: 
		repopulate_dropdown = false
		populate_dropdown_with_filters(metadata_counts, $metadata_filters)


func display_file(file_name, file_extension, parent_container):
	var file_container = VBoxContainer.new()
	parent_container.add_child(file_container)

	var texture_rect = TextureRect.new()
	file_container.add_child(texture_rect)

	if file_extension == "jpg" or file_extension == "png":
		var image_texture = ImageTexture.create_from_image(Image.load_from_file(path + "/" + file_name))
		image_texture.set_size_override(Vector2i(128, 128))
		texture_rect.texture = image_texture

	elif file_extension == "ogv":
		var hidden_screen = TextureRect.new()
		parent_container.add_child(hidden_screen)

		var video_player = VideoStreamPlayer.new()
		hidden_screen.add_child(video_player)
		hidden_screen.hide()
		video_player.stream = load(path + "/" + file_name)
		video_player.play()

		await get_tree().create_timer(0.001).timeout  # Wait for the first frame to be rendered

		var thumbnail = video_player.get_video_texture().get_image()
		var thumbnail_texture = ImageTexture.create_from_image(thumbnail)
		thumbnail_texture.set_size_override(Vector2i(128, 128))
		texture_rect.texture = thumbnail_texture

		video_player.queue_free()

	var nBut = Button.new()
	nBut.text = file_name
	file_container.add_child(nBut)
	nBut.pressed.connect(open_file.bind(file_name))


func read_metadata_file(file_path: String) -> Dictionary:
	var predictions = {}
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open .json file: " + file_path)
		return predictions
	
	var json_string = file.get_as_text()
	var data_json = JSON.parse_string(json_string)
	file.close()
	
	if "predictions" in data_json:
		for prediction in data_json["predictions"]:
			predictions[prediction["label"]] = prediction["probability"]
	else:
		push_error("No 'predictions' key found in JSON file: " + file_path)
	#print_debug("Predictions is: " + str(predictions))
	
	return predictions
	

func read_metadata_analysis(file_path: String) -> Dictionary:
	var metadata_counts = {}

	# Open the file
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open .txt file: " + file_path)
		return metadata_counts
	
	# Read each line of the file
	while !file.eof_reached():
		var line = file.get_line().strip_edges()  # Read and strip leading/trailing whitespace
		var parts = line.split(":")  # Split the line by ":"
		
		# Check if the line is properly formatted
		if parts.size() == 2: 
			var label = parts[0]  # Extract the label
			var count = int(parts[1])# Extract the count and convert to integer
			
			# Add the label and count to the metadata_counts dictionary
			metadata_counts[label] = count
	
	# Close the file
	file.close()

	return metadata_counts


func populate_dropdown_with_filters(metadata_counts: Dictionary, dropdown: OptionButton):
	print_debug("Populating dropdown")
	# Clear existing options
	dropdown.clear()
	
	
	# Add an option for the total count
	dropdown.add_item("no filter")

	# Add filter options to the dropdown menu
	for label in metadata_counts.keys():
		dropdown.add_item(label)

func _on_up_pressed(): # for some reason it crashes when videos dir/thumbnails not finished loading all
	if file: path = path.get_base_dir()
	path = path.get_base_dir()
	$metadata_filters.clear()
	set_layout("", true)

func _on_path_text_submitted(new_text:String):
	if new_text.is_absolute_path():
		path = new_text
		set_layout()
	else:
		Npath.clear()


func _on_open_pressed():
	emit_signal("done", Npath.text)
	queue_free()
	



func _on_cancel_pressed():
	queue_free()


func _on_pin_pressed():
	var npath = path
	if file: npath = npath.get_base_dir()
	var nam = npath.get_file()
	Globals.pinned.append([nam, npath])
	add_pinned_button([nam, npath])


func _on_addf_pressed():
	$add_folder.hide()
	if file: path = path.get_base_dir()
	var dir = DirAccess.open(path)
	dir.make_dir_absolute(path + "/" + $add_folder/newname.text)
	set_layout()

func _on_cancelf_pressed():
	$add_folder.hide()

func _on_new_folder_pressed():
	$add_folder.show()

func _on_search_bar_text_submitted(new_text): # used submitted instead of changed due to perfomances issue from reloading thumbnails (typing too slow)
	set_layout(new_text)


func _on_metadata_filters_item_selected(index):
	selected_filter_index = index
	set_layout("", false)


func _on_filter_check_toggled(button_pressed):
	print_debug("filter check button is:" + str(button_pressed))
	set_layout("", true)
