extends Control

@export var lblName : Label
@export var lblPerc : Label

@export var audioSlider : HSlider


var audio_settings : GlobalGameSettings

#the audio bus that we change
var audio_bus : int = 0

#sets the audio bus that we will change and control in the game
func set_bus(bus_number : int )->void:
	lblName.set_text(AudioServer.get_bus_name(bus_number))
	audio_bus = bus_number

func _ready()->void:
	self.sync_display()
	self.audioSlider.drag_started.connect(self.on_drag_started)

func on_drag_started()->void:
	#load up the global game settings from the disk
	audio_settings = GlobalGameSettings.load_settings()

#returns the volumne of our audio bus as a linear 
func get_linear_vol()->float:
	return 100*db_to_linear(AudioServer.get_bus_volume_db(audio_bus)) 

func _on_h_slider_drag_ended(changed : bool)->void:
	#save the settings back out to the disk
	audio_settings.save_settings()
	audio_settings = null

func sync_display()->void:
	print_debug(self.get_linear_vol())
	self.lblPerc.text = "%d%"%(self.get_linear_vol())


func _on_hslider_audio_value_changed(value : float)->void:
	if audio_settings:
		audio_settings.set_audio_vol_from_linear(self.audio_bus,self.audioSlider.value/100)
	self.sync_display()
