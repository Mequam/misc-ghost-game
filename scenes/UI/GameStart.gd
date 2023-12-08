extends BackStackControl

class_name MainMenu

func _ready()->void:
	#sync all of the settings on game load
	var settings = GlobalGameSettings.load_settings()
	settings.sync_settings()
	super._ready()
