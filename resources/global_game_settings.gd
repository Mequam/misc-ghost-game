extends Resource

#this resource represents settings that are saved in the game
#REGARUDLESS of save
#things like audio settings and control settings live here

class_name GlobalGameSettings

@export var control_remaps : Dictionary
@export var bus_vol_db : Dictionary
@export var screen_resolution : Vector2i
@export var color_remaps : Dictionary #mapping from one color to another color


#stores and syncs the given resolution
func set_screen_resolution(screen_resolution : Vector2i,tree : SceneTree)->void:
	self.screen_resolution = screen_resolution
	self.sync_resoution_to_settings(tree)

func get_resolution_scale()->float:
	var development_resolution = Vector2i(1152,648)
	return development_resolution.x / self.screen_resolution.x

#sets the audio bus from a linear vol
#note that linear_vol ranges from 0 to 1
func set_audio_vol_from_linear(audio_bus : int, linear_vol : float)->void:
	var db_vol = linear_to_db(linear_vol)
	AudioServer.set_bus_volume_db(audio_bus,db_vol)
	bus_vol_db[AudioServer.get_bus_name(audio_bus)] = db_vol

#syncs the live state of the game to that of the resource
#the one exception to this are settings that are used when the main
#game scene is loaded, those need to be set in that scene on load
func sync_settings(tree : SceneTree)->void:
	self.sync_audio_to_settings()
	self.sync_input_map_to_settings()
	self.sync_resoution_to_settings(tree)

#syncs audio settings to the ones on disc
func sync_audio_to_settings()->void:
	for bus_name in self.bus_vol_db:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name),self.bus_vol_db[bus_name])

#syncs the game resolution to the one stored in the settings
func sync_resoution_to_settings(tree : SceneTree)->void:
	tree.get_root().content_scale_size = self.screen_resolution

	print_debug(tree.get_root().content_scale_factor)
	
	var dev_dimensions = Vector2i(1152, 648)
	#tree.get_root().content_scale_factor = (self.screen_resolution.x*self.screen_resolution.y)/float(dev_dimensions.x*dev_dimensions.y)

	print_debug("res : " + str(tree.get_root().content_scale_size))

#syncs the stored input map to the game input map
func sync_input_map_to_settings()->void:
	for action in control_remaps:
		self.add_remap(action,control_remaps[action])

#adds a remap to the exported remap variable
func add_remap(action : String,event : InputEvent)->void:
	#add it to the disk data
	control_remaps[action] = event

	#add it to the live data
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action,event)

#removes a remap from the remap export variable
#and resets the action to the initial project settings
func remove_remap(action : String)->void:
	#remove it from the disk data
	control_remaps.erase(action)

	#remove it from the live data
	InputMap.action_erase_events(action)
	var events = ProjectSettings.get_setting("input/" + action)["events"]
	for event in events:
		InputMap.action_add_event(action,event)

#saves the current global settings to disk
func save_settings()->void:
	ResourceSaver.save(self,"user://global_settings.tres")

#returns the current global settings
static func load_settings()->GlobalGameSettings:
	if FileAccess.file_exists("user://global_settings.tres"):
		return ResourceLoader.load("user://global_settings.tres")
	return GlobalGameSettings.new()

