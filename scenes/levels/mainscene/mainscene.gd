extends Control
#this script represents the main scene of the game where everything else is loaded from
#logic that affects the entire game can be placed in here, think if it like a game container for loading and unloading
#stuff

#this is also where screen space shaders live and the like

class_name MainScene


# Called when the node enters the scene tree for the first time.
func _ready():
	#we need to load the last save if this is our first time loading the main scene
	GameLoader.load_save()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
