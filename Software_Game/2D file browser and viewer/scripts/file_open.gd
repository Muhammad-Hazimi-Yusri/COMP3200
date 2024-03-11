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


func _on_open_pressed():
	emit_signal("open", $path.text)

func _on_quit_pressed():
	emit_signal("quit")
