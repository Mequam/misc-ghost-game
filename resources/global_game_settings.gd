extends Resource

#this resource represents settings that are saved in the game
#REGARUDLESS of save
#things like audio settings and control settings live here

class_name GlobalGameSettings

@export var control_remaps : Dictionary


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

