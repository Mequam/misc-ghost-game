extends Control
#this script represents the main scene of the game where everything else is loaded from
#logic that affects the entire game can be placed in here, think if it like a game container for loading and unloading
#stuff

#this is also where screen space shaders live and the like

class_name MainScene

#displays the hearts that the currently possesed entity has
@export var heart_tracker : HeartTracker
#contains the sound system for the game
@export var music_system : SoundTree

# Called when the node enters the scene tree for the first time.
func _ready():
	#we need to load the last save if this is our first time loading the main scene
	GameLoader.load_save()
	
	#start the sound system playing
	music_system.play()

