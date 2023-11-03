extends VideoStreamPlayer

func _ready():
	if material:
		material.set_shader_parameter("time", 0.0)  # Set the "time" uniform to 0.0

# You can update the "time" uniform in the _process function
func _process(delta):
	if material:
		material.set_shader_parameter("time", material.get_shader_parameter("time") + delta)
