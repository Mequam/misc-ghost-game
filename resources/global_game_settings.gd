extends Resource

#this resource represents settings that are saved in the game
#REGARUDLESS of save
#things like audio settings and control settings live here

class_name GlobalGameSettings

@export var control_remaps : Dictionary
@export var bus_vol_db : Dictionary

#sets the audio bus from a linear vol
#note that linear_vol ranges from 0 to 1
func set_audio_vol_from_linear(audio_bus : int, linear_vol : float)->void:
	var db_vol = linear_to_db(linear_vol)
	AudioServer.set_bus_volume_db(audio_bus,db_vol)
	bus_vol_db[AudioServer.get_bus_name(audio_bus)] = db_vol

#syncs the live state of the game to that of the resource
func sync_settings()->void:
	self.sync_audio_to_settings()
	self.sync_input_map_to_settings()

func sync_audio_to_settings()->void:
	for bus_name in self.bus_vol_db:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name),self.bus_vol_db[bus_name])

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

