extends Control

#the container for all of the audio sliders
@export var audio_slider_container : Control
@export var audio_slider : PackedScene

func create_audio_slider(bus_number : int)->Control:
	var audio_slide = audio_slider.instantiate()
	audio_slide.set_bus(bus_number)
	return audio_slide
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(AudioServer.bus_count):
		self.audio_slider_container.add_child(self.create_audio_slider(i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
