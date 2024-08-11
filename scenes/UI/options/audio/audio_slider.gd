extends Control

@export var lblName : Label
@export var lblPerc : Label

@export var audioSlider : HSlider

@export var sliderLenis : Array[Texture2D]

@export var audio_overkill_perc : float = 2


var audio_settings : GlobalGameSettings

#the audio bus that we change
var audio_bus : int = 0

#sets the audio bus that we will change and control in the game
func set_bus(bus_number : int )->void:
	var bus_name : StringName = AudioServer.get_bus_name(bus_number) 
	lblName.set_text(bus_name)
	audio_bus = bus_number
	audioSlider.value = audioSlider.max_value*db_to_linear(AudioServer.get_bus_volume_db(bus_number))/self.audio_overkill_perc
	$AudioStreamPlayer.set_bus(bus_name)
	self.sync_display()

func _ready()->void:
	self.sync_display()
	self.audioSlider.drag_started.connect(self.on_drag_started)

func on_drag_started()->void:
	#load up the global game settings from the disk
	audio_settings = GlobalGameSettings.load_settings()

#returns the volumne of our audio bus as a linear 
func get_linear_vol()->float:
	return audioSlider.max_value*db_to_linear(AudioServer.get_bus_volume_db(audio_bus))/self.audio_overkill_perc 

func _on_h_slider_drag_ended(_changed : bool)->void:
	#save the settings back out to the disk
	audio_settings.save_settings()
	audio_settings = null
	
	$AudioStreamPlayer.volume_db = db_to_linear(self.audio_overkill_perc * self.audioSlider.value/self.audioSlider.max_value)
	$AudioStreamPlayer.play()

func get_appropriate_slider_leni()->Texture2D:
	var x = int((len(sliderLenis)-1)*(audioSlider.value+10)/100)
	return sliderLenis[x if x < len(sliderLenis) else len(sliderLenis)-1]


func sync_display()->void:
	audioSlider.add_theme_icon_override("grabber",get_appropriate_slider_leni())
	audioSlider.add_theme_icon_override("grabber_highlight",get_appropriate_slider_leni())
	self.lblPerc.text = "%d"%(self.audio_overkill_perc*self.get_linear_vol())+"%"
	lblPerc.add_theme_color_override("background_color",Color.WHITE if audioSlider.value < 49 else Color.BLACK)


func _on_hslider_audio_value_changed(value : float)->void:
	if audio_settings:
		audio_settings.set_audio_vol_from_linear(self.audio_bus,
			self.audio_overkill_perc*self.audioSlider.value/self.audioSlider.max_value)
	self.sync_display()
