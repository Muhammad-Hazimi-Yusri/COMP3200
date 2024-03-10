extends Control

@onready var file_open_dialog = $"file open"
@onready var image_display = $ImageDisplay

func _ready():
	pass

func _on_file_open_dialog_open(path: String):
	if path.get_extension() == "jpg":
		var image = Image.load_from_file(path)
		var texture = ImageTexture.create_from_image(image)
		print_debug("path is:" + path)
		#var texture = load("res://Sample-JPEG-Image-File-Download-scaled.jpg")
		image_display.texture = texture
		image_display.show()
		print_debug("HI")
	elif path.get_extension() == "ogv":
		pass


func _on_image_disp_button_pressed():
	image_display.hide()
