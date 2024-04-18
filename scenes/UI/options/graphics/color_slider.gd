extends Control
@export var h_slider : HSlider
@export var spin_box : SpinBox

@export var out_max : int = 255
@export var out_min : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	spin_box.max_value = self.out_max
	spin_box.min_value = self.out_min
	h_slider.value_changed.connect(self.on_val_changed)



func on_val_changed(val : float)->void:
	#print_debug(h_slider.value/h_slider.max_value)
	spin_box.value = int(
								lerp(
										float(out_min),
										float(out_max),
										h_slider.value/h_slider.max_value)
								)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
