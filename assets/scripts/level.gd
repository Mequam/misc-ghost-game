extends Node2D
#this script is the generic level class intenaded
#to be given to any main level node that has entity nodes as children 

class_name Level

#the "speed" of the ai
@export 
var ai_timeout : float = 20

#the load path for this level, used for saving stuff
@export var load_path : String

#reference to the main camera for the level
@export
var cam_ref : Camera2D :
	get:
		return cam_ref # TODOConverter40 Copy here content of get_cam_ref
	set(mod_value):
		cam_ref = mod_value  # TODOConverter40 Copy here content of set_cam_ref
func set_cam_ref(ref : Camera2D)->void:
	cam_ref = ref
	set_cam_limit()
func get_cam_ref()->Camera2D:
	return cam_ref 

#dertermines if the player is allowed to leave the level
@export 
var allow_escape : bool = false

var cam_limit_left = -908
func set_cam_limit()->void:
	cam_ref.limit_left = -908
	cam_ref.limit_right = 828
	cam_ref.limit_bottom = 192

#level data loaded in from the disc when we load this level
var level_data : Dictionary

#global reference to the possesed entity for conveinence
#set on ready in the level script
var player_entity : Entity 

func _ready():
	#set up the timer that will run the ai for the game
	var ai_timer = Timer.new()
	add_child(ai_timer)
	ai_timer.wait_time = ai_timeout 
	ai_timer.connect("timeout",Callable(self,"on_ai_timeout"))
	ai_timer.start()

	cam_ref.limit_left = cam_limit_left

	#start out grabbing Leni if he is in the tree
	if $Leni:
		$Leni.grab_camera()
		player_entity = $Leni 

func _on_tree_entered()->void:
	print("level entered tree!")

func call_ai(aggro_entity):
	get_tree().call_group("Npc","run_AI",aggro_entity)

func _process(_delta):
	if Input.is_key_pressed(KEY_P):
		GameLoader.load_level(
			load("res://scenes/levels/leni_load_test.tscn"),
			self,
			[$mainCam,$Leni,$witch]
			)	

func on_ai_timeout():
	call_ai(player_entity)

#after we finish loading, allow the player to escape
func on_load(persist_objects,caller)->void:
	#make sure to wait for the game to update positions
	await get_tree().create_timer(0.5).timeout
	self.allow_escape = true
	pass
