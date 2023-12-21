extends VBoxContainer

@export var hue_slider : HSlider
@export var sat_slider : HSlider
@export var val_slider : HSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	hue_slider.value_changed.connect(hue_changed)
	sat_slider.value_changed.connect(sat_changed)
	val_slider.value_changed.connect(val_changed)


func get_slider_perc(slider : HSlider)->float:
	return slider.value / slider.max_value
#syncs the display to align with the values of each of the sliders
func sync_hsv()->void:
	hue_slider.get_parent().material.set_shader_parameter("satf",get_slider_perc(sat_slider))
	val_slider.get_parent().material.set_shader_parameter("satf",get_slider_perc(sat_slider))

	sat_slider.get_parent().material.set_shader_parameter("huef",get_slider_perc(hue_slider))
	val_slider.get_parent().material.set_shader_parameter("huef",get_slider_perc(hue_slider))

	hue_slider.get_parent().material.set_shader_parameter("valf",get_slider_perc(val_slider))
	sat_slider.get_parent().material.set_shader_parameter("valf",get_slider_perc(val_slider))

func get_color()->Color:
	return Color.from_hsv(
							get_slider_perc(hue_slider),
							get_slider_perc(val_slider),
							get_slider_perc(val_slider)
						)

func val_changed(_val : float)->void:
	sync_hsv()
func sat_changed(_val : float)->void:
	sync_hsv()
func hue_changed(_val : float)->void:
	sync_hsv()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
