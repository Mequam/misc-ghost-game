extends HBoxContainer

@export var width_control : SpinBox
@export var height_control : SpinBox
@export var btn_save : Button
@export var btn_restore : Button
@export var btn_reset : Button

#reference to an item list containing different resolution presents
@export var resolution_presents : ItemList

func sync_spin_boxes()->void:
	var size : Vector2i = get_tree().get_root().content_scale_size
	width_control.value = size.x
	height_control.value = size.y

func sync_present_selection()->void:
	var aspect_size : Vector2i = get_tree().get_root().content_scale_size
	
	#ensure that if we are using a present we indicate that to the user
	for i in range(resolution_presents.item_count):
		if get_resolution_present(i) == aspect_size:
			resolution_presents.select(i)
			return
	#if nothing is selected, ensure that we indicate the present is not selected
	resolution_presents.deselect_all()

func sync_display()->void:
	self.sync_spin_boxes()
	self.sync_present_selection()

	#ensure that the proper save button is visible
	self.update_save_visibility()
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	self.sync_display()


	width_control.value_changed.connect(self.on_width_control_changed)
	height_control.value_changed.connect(self.on_height_control_changed)

	btn_save.pressed.connect(on_btn_save_pressed)
	btn_restore.pressed.connect(on_btn_restore_pressed)
	btn_reset.pressed.connect(on_btn_reset_pressed)
	resolution_presents.item_selected.connect(self.on_present_selected)



	self.sync_spin_boxes()

func on_btn_reset_pressed()->void:
	var settings : GlobalGameSettings = GlobalGameSettings.load_settings()
	settings.set_screen_resolution(Vector2i(1152,648),get_tree())
	settings.save_settings()

	self.sync_display()

func get_resolution_present(idx : int)->Vector2i:
	if resolution_presents.item_count <= idx: return Vector2i(0,0)
	var split_data = resolution_presents.get_item_text(idx).split(" ")
	var present : Vector2i = Vector2i(int(split_data[0]),int(split_data[2]))
	return present
func on_present_selected(idx : int)->void:
	var present = get_resolution_present(idx)
	#create and save the game resolution settings!
	var settings : GlobalGameSettings = GlobalGameSettings.load_settings()
	settings.set_screen_resolution(present,get_tree())
	settings.save_settings()

	self.sync_display()



func on_btn_restore_pressed()->void:
	self.sync_display()

func on_btn_save_pressed()->void:
	
	#load and store the settings
	var settings : GlobalGameSettings = GlobalGameSettings.load_settings()
	settings.set_screen_resolution(Vector2i(int(width_control.value),int(height_control.value)),get_tree())
	settings.save_settings()
	
	self.sync_display()

func update_save_visibility()->void:
	var resolution : Vector2i = get_tree().get_root().content_scale_size
	print_debug(width_control.value == resolution.x or height_control.value == resolution.y)
	btn_save.visible = (width_control.value != resolution.x or height_control.value != resolution.y)
	btn_restore.visible = btn_save.visible

func on_width_control_changed(_value : float)->void:
	update_save_visibility()
func on_height_control_changed(_value : float)->void:
	update_save_visibility()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
