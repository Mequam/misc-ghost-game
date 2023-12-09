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
#reference to the pause menu
@export var pause_menu : Control
#refernece to the container that the levels are run on
@export var level_container : Node2D

#runtime variables that are not saved
#this is for things like enemies remembering their deaths, 
#and powerups staying removed between scenes
var runtime_variables : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	#we need to load the last save if this is our first time loading the main scene
	GameLoader.load_save()


	#start the sound system playing
	music_system.play()

#pauses the game and opens appropriate menus
func pause()->void:
	self.pause_menu.visible = true

	#tell the pause menu to wait for key up before it can unpause
	#so we do not instantly snap back from pausing
	self.pause_menu.can_unpause = false
	self.heart_tracker.visible = false
	get_tree().paused = true

#unpauses the game and sets the propper nodes to visible
func unpause()->void:
	self.pause_menu.visible = false 
	self.heart_tracker.visible = true 
	#clear the players current inputs
	get_level().player_entity.clear_stored_inputs()
	get_tree().paused = false

func get_level()->Level:
	return level_container.get_child(1)

func _process(_delta : float)->void:
	if Input.is_action_just_pressed("PAUSE"):
		self.pause()
