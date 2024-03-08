#@tool
extends Control


@onready var FolderScene = preload("res://Tools/FileBrowser/Folder.tscn")
@onready var FolderMenuScene = preload("res://Tools/FileBrowser/FolderMenu.tscn")
@onready var FileScene = preload("res://Tools/FileBrowser/File.tscn")
@onready var FileMenuScene = preload("res://Tools/FileBrowser/FileMenu.tscn")
@onready var timer: Timer = $Timer

var directory : String = _get_root_directory() : set = _update_dir
var clicked_object
var menu: MarginContainer
var history : Array[String] = [directory]
var history_idx : int = 0
var system_directories = [
	OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP),
	OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS),
	OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS),
	OS.get_system_dir(OS.SYSTEM_DIR_MUSIC),
	OS.get_system_dir(OS.SYSTEM_DIR_PICTURES),
]


##########################################################################
################################# PUBLIC #################################
##########################################################################


func copy_directory(from_dir: String, to_dir: String):
	if !DirAccess.dir_exists_absolute(from_dir):
		push_error("Directory copy: from_dir=%s does not exist" % from_dir)
		return

	if !DirAccess.dir_exists_absolute(to_dir):
		DirAccess.make_dir_recursive_absolute(to_dir)

	for file in DirAccess.get_files_at(from_dir):
		DirAccess.copy_absolute("%s/%s" % [from_dir, file], "%s/%s" % [to_dir, file])

	for sub_folder in DirAccess.get_directories_at(from_dir):
		copy_directory("%s/%s" % [from_dir, sub_folder], "%s/%s" % [to_dir, sub_folder])


func rename_directory(from_dir: String, to_dir: String):
	var error := DirAccess.rename_absolute(from_dir, to_dir)
	if error != OK:
		push_error("Error during move/rename operation: %s" % error)


func move_directory(from_dir: String, to_dir: String):
	DirAccess.make_dir_recursive_absolute(to_dir.get_base_dir())
	return rename_directory(from_dir, to_dir)


func move_file(from_file: String, to_file: String):
	DirAccess.make_dir_recursive_absolute(to_file.get_base_dir())
	return rename_directory(from_file, to_file)


func get_native_path(path):
	var globalized_path = ProjectSettings.globalize_path(path)
	if OS.get_name() == "Windows":
		return globalized_path.replace("//", "/").replace("/", "\\")
	return globalized_path


###########################################################################
################################# PRIVATE #################################
###########################################################################


func _input(event):
	if event is InputEventMouseButton and menu != null and !menu.get_global_rect().has_point(event.position):
		menu.queue_free()


func _ready():
	_update_dir(directory)

	var button = Button.new()
	var stylebox_normal : StyleBoxFlat = button.get_theme_stylebox("normal").duplicate()
	var stylebox_hover : StyleBoxFlat = button.get_theme_stylebox("hover").duplicate()
	stylebox_normal.bg_color = Color(0, 0, 0, 0)
	stylebox_hover.bg_color = Color(0.3, 0.3, 0.3, 1)
	button.queue_free()

	for dir in system_directories:
		var margin_container := MarginContainer.new()
		margin_container.add_theme_constant_override("margin_left", 1)
		margin_container.add_theme_constant_override("margin_right", 1)
		margin_container.add_theme_constant_override("margin_top", 1)
		margin_container.add_theme_constant_override("margin_bottom", 1)

		var system_dir_shortcut := Button.new()
		system_dir_shortcut.custom_minimum_size = Vector2i(0, 70)
		system_dir_shortcut.text = dir.get_file()
		system_dir_shortcut.name = dir.get_file()
		system_dir_shortcut.add_theme_font_size_override("font_size", 22)
		system_dir_shortcut.add_theme_stylebox_override("normal", stylebox_normal)
		system_dir_shortcut.add_theme_stylebox_override("hover", stylebox_hover)
		system_dir_shortcut.pressed.connect(_on_path_container_button_pressed.bind(dir))

		margin_container.add_child(system_dir_shortcut)
		system_dir_shortcut.set_owner(margin_container)
		%ShortcutsContainer.add_child(margin_container)
		margin_container.set_owner(%ShortcutsContainer)


func _get_root_directory():
	match OS.get_name():
		"Windows":
			return "C://"

		"Linux":
			return "/"

		"Android":
			# FIXME: Probably won't work
			return "/root"


func _update_dir(new_directory):
	if menu != null:
		menu.queue_free()
		menu = null

	# TODO: If exists and is dir
	directory = new_directory
	var dir := DirAccess.open(directory)
	if dir == null:
		return

	var normalized_path := dir.get_current_dir()
	var parts := normalized_path.split("/", false)

	for child in %PathContainer.get_children():
		%PathContainer.remove_child(child)

	var current_path : String = ""
	for part in parts:
		current_path += part + "/"

		var margin_container := MarginContainer.new()
		margin_container.add_theme_constant_override("margin_left", 1)
		margin_container.add_theme_constant_override("margin_right", 1)
		margin_container.add_theme_constant_override("margin_top", 1)
		margin_container.add_theme_constant_override("margin_bottom", 1)

		var button := Button.new()
		button.text = part
		button.custom_minimum_size = Vector2i(70, 50)
		button.pressed.connect(_on_path_container_button_pressed.bind(current_path))
		button.add_theme_font_size_override("font_size", 22)

		margin_container.add_child(button)
		button.set_owner(margin_container)
		%PathContainer.add_child(margin_container)
		margin_container.set_owner(%PathContainer)


	for child in %DirectoryContentsContainer.get_children():
		%DirectoryContentsContainer.remove_child(child)

	for folder in dir.get_directories():
		if folder.begins_with("."):
			continue

		var folder_entry = FolderScene.instantiate()
		folder_entry.folder_name = folder
		folder_entry.folder_clicked.connect(_on_entry_clicked)
		%DirectoryContentsContainer.add_child(folder_entry)
		folder_entry.set_owner(%DirectoryContentsContainer)

	for file in dir.get_files():
		if file.begins_with(".") or file.begins_with("_"):
			continue

		var file_entry = FileScene.instantiate()
		file_entry.file_name = file
		file_entry.file_clicked.connect(_on_entry_clicked)
		%DirectoryContentsContainer.add_child(file_entry)
		file_entry.set_owner(%DirectoryContentsContainer)


func _update_history(backwards := false, upwards := false):
	if backwards:
		while history_idx > 0 and history[history_idx] != directory:
			history_idx -= 1

	elif upwards:
		history = history.slice(0, history_idx + 1)
		history.append(directory)
		history_idx += 1

	# if the directory is forward in history, change the index
	elif history_idx + 1 < len(history) and directory == history[history_idx + 1]:
		history_idx += 1

	# if the directory is not foward in history, drop new values and append
	elif not directory in history:
		history = history.slice(0, history_idx + 1)
		history.append(directory)
		history_idx += 1


###########################################################################
################################# SIGNALS #################################
###########################################################################


func _on_entry_clicked(event, entry):
	if !event.pressed:
		# Drag and drop?
		return

	clicked_object = entry

	if menu != null:
		menu.queue_free()
		menu = null

	timer.stop()
	if event.double_click:
		if entry is Folder:
			directory = directory.path_join(entry.folder_name)
			_update_history()
		else:
			print("Opening file %s..." % entry.file_name)

	else:
		timer.start()


func _on_path_container_button_pressed(current_path):
	directory = current_path
	_update_history()


func _on_mouse_click_detect_timer_timeout():
	var object_path: String
	if clicked_object is Folder:
		menu = FolderMenuScene.instantiate()
		object_path = directory.path_join(clicked_object.folder_name)
		menu.get_node("%Open").pressed.connect(_on_path_container_button_pressed.bind(object_path))

	else:
		menu = FileMenuScene.instantiate()
		object_path = directory.path_join(clicked_object.file_name)

	# Buttons handled the same way
	menu.get_node("%CopyPath").pressed.connect(DisplayServer.clipboard_set.bind(get_native_path(object_path)))

	add_child(menu)
	menu.set_owner(self)
	# TODO: Add logic to make sure this doesn't go out of bounds and/or looks prettier
	menu.global_position = clicked_object.global_position - Vector2(menu.size.x, 0)


func _on_up_button_pressed():
	directory = directory.get_base_dir()
	_update_history(false, true)



func _on_forward_button_pressed():
	if history_idx + 1 < len(history):
		directory = history[history_idx + 1]
		_update_history()


func _on_back_button_pressed():
	if history_idx > 0:
		directory = history[history_idx - 1]
		_update_history(true)
