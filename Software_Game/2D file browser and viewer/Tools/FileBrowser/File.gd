@tool
extends MarginContainer
class_name File


signal file_clicked(event: InputEvent, file: File)


@export var file_name : String = "" : set = _set_file_name, get = _get_file_name


func _enter_tree():
	%FileName.text = file_name


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _set_file_name(new_name):
	file_name = new_name
	%FileName.text = new_name


func _get_file_name():
	return file_name


func _on_gui_input(event):
	if event is InputEventMouseButton:
		emit_signal("file_clicked", event, self)
