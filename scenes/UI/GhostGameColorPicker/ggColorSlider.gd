extends VBoxContainer

@export var hue_slider : HSlider
@export var sat_slider : HSlider
@export var val_slider : HSlider

@export var color_picker : ColorPicker


# Called when the node enters the scene tree for the first time.
func _ready():
	hue_slider.value_changed.connect(hue_changed)
	sat_slider.value_changed.connect(sat_changed)
	val_slider.value_changed.connect(val_changed)

	#ensure that every one of our sliders has a unique material
	for node in get_children():
		var color_rect = node.get_node("ColorRect3")
		if color_rect:
			color_rect.material = color_rect.material.duplicate() 

	color_picker.color_changed.connect(self.on_color_picker_changed)

func on_color_picker_changed(c : Color)->void:
	sync_slider_values_from_color(c)
	sync_from_color(c)

func get_slider_perc(slider : HSlider)->float:
	return slider.value / slider.max_value 

func sync_slider_values_from_color(c : Color)->void:
	hue_slider.value = int(c.h*100)
	val_slider.value = int(c.v*100)
	sat_slider.value = int(c.s*100)
func sync_from_color(c : Color)->void:


	hue_slider.get_parent().material.set_shader_parameter("satf",c.s)
	val_slider.get_parent().material.set_shader_parameter("satf",c.s)

	sat_slider.get_parent().material.set_shader_parameter("huef",c.h)
	val_slider.get_parent().material.set_shader_parameter("huef",c.h)

	hue_slider.get_parent().material.set_shader_parameter("valf",c.v)
	sat_slider.get_parent().material.set_shader_parameter("valf",c.v)

#syncs the display to align with the values of each of the sliders
func sync_hsv()->void:
	sync_from_color(get_color())
	color_picker.color = get_color()
	print("syncing hsv")


func get_color()->Color:
	return Color.from_hsv(
							get_slider_perc(hue_slider),
							get_slider_perc(sat_slider),
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
