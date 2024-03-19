extends ColorRect

@export var Title:String = ""
@export var limited:Array = []

const file_explorer = preload("res://scenes/file_explorer.tscn")

signal quit
signal open(path:String)

# Called when the node enters the scene tree for the first time.
func _ready():
	$title.text = Title
	
func new_path(path:String):
	$path.text = path

func _on_browse_pressed():
	var nExplor = file_explorer.instantiate()
	get_parent().add_child(nExplor)
	nExplor.limited = limited
	nExplor.done.connect(new_path)
	var path_browse = $path.text
	if DirAccess.open(path_browse): # retain browse dir if its a DIR
		nExplor.to_dir(path_browse)
	elif  DirAccess.open(path_browse.get_base_dir()):
		nExplor.to_dir(path_browse.get_base_dir())


func _on_open_pressed():
	emit_signal("open", $path.text)
	Globals.play.emit() # this causes bug with SBS_Screen showing sporadically 
	# ok maybe not, it was the file = false change prob.

func _on_quit_pressed():
	emit_signal("quit")

