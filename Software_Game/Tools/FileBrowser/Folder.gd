@tool
extends MarginContainer
class_name Folder


signal folder_clicked(event: InputEvent, folder: Folder)


@export var folder_name : String = "" : set = _set_folder_name, get = _get_folder_name


##########################################################################
################################# PUBLIC #################################
##########################################################################


###########################################################################
################################# PRIVATE #################################
###########################################################################


func _enter_tree():
	%FolderName.text = folder_name


func _set_folder_name(new_name):
	folder_name = new_name
	%FolderName.text = new_name


func _get_folder_name():
	return folder_name


###########################################################################
################################# SIGNALS #################################
###########################################################################


func _on_gui_input(event):
	if event is InputEventMouseButton:
		emit_signal("folder_clicked", event, self)
