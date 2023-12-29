extends HBoxContainer

@export var width_control : SpinBox
@export var height_control : SpinBox
@export var btn_save : Button
@export var btn_reset : Button

# Called when the node enters the scene tree for the first time.
func _ready():
	var size : Vector2i = get_tree().get_root().content_scale_size
	width_control.value = size.x
	height_control.value = size.y

	width_control.value_changed.connect(self.on_width_control_changed)
	height_control.value_changed.connect(self.on_height_control_changed)

	btn_save.pressed.connect(on_btn_save_pressed)
	btn_reset.pressed.connect(on_btn_reset_pressed)

func on_btn_reset_pressed()->void:
	var size : Vector2i = get_tree().get_root().content_scale_size
	width_control.value = size.x
	height_control.value = size.y
	#ensure that we can see (or not see) the save button
	update_save_visibility()

func on_btn_save_pressed()->void:
	
	#load and store the settings
	var settings : GlobalGameSettings = GlobalGameSettings.load_settings()
	settings.set_screen_resolution(Vector2i(int(width_control.value),int(height_control.value)),get_tree())
	settings.save_settings()

	update_save_visibility()

func update_save_visibility()->void:
	var resolution : Vector2i = get_tree().get_root().content_scale_size
	print_debug(width_control.value == resolution.x or height_control.value == resolution.y)
	btn_save.visible = (width_control.value != resolution.x or height_control.value != resolution.y)

func on_width_control_changed(_value : float)->void:
	update_save_visibility()
func on_height_control_changed(_value : float)->void:
	update_save_visibility()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
