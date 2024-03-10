extends ColorRect

@onready var cont = $ScrollContainer/GridContainer
@onready var pinned = $pinned/pinned_container
@onready var Npath = $path

var path:String = ""
var file:bool = false

var limited = []

signal done(path:String)

# Called when the node enters the scene tree for the first time.
func _ready():
	path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
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
	path = path + "/" + file_name
	Npath.text = path
	file = true

func set_layout():
	file = false
	Npath.text = path
	for i in cont.get_children(): i.queue_free()
	
	var dir=DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if dir.current_is_dir():
			var nBut = Button.new()
			nBut.text = file_name
			cont.add_child(nBut)
			nBut.pressed.connect(open_folder.bind(file_name))
			nBut.add_theme_stylebox_override("normal", load("res://folder_box.tres"))
		else:
			var file_container = VBoxContainer.new()
			cont.add_child(file_container)

			var texture_rect = TextureRect.new()
			file_container.add_child(texture_rect)

			if file_name.get_extension() in limited:
				var image_texture = Image.load_from_file(path + "/" + file_name)
				var scaled_texture = ImageTexture.create_from_image(image_texture)
				scaled_texture.set_size_override(Vector2i(128, 128))
				texture_rect.texture = scaled_texture

			var nBut = Button.new()
			nBut.text = file_name
			file_container.add_child(nBut)
			nBut.pressed.connect(open_file.bind(file_name))

			if limited.size() > 0:
				if !file_name.get_extension() in limited:
					file_container.queue_free()

		file_name = dir.get_next()

func _on_up_pressed():
	if file: path = path.get_base_dir()
	path = path.get_base_dir()
	set_layout()

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
