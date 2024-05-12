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
func get_cam_ref()->Camera2D:
	return cam_ref 

#dertermines if the player is allowed to leave the level
@export 
var allow_escape : bool = false

@export var color_rotation : Color = Color.WHITE
@export var red_map : Color = Color.RED
@export var ygreen_map : Color = Color.GREEN


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

	#sync up the color of the main display to this levels mapping colors
	var color_mat = get_main().color_container.material
	color_mat.set_shader_parameter("ColorRotation",self.color_rotation)
	color_mat.set_shader_parameter("red_map",self.red_map)
	color_mat.set_shader_parameter("yg_map",self.ygreen_map)
		
	#start out grabbing Leni if he is in the tree
	if $Leni:
		$Leni.grab_camera()
		player_entity = $Leni 
	RenderingServer.set_default_clear_color(Color.from_hsv(0,100,100))

func _on_tree_entered()->void:
	print("level entered tree!")

func call_ai(aggro_entity):
	get_tree().call_group("Npc","run_AI",aggro_entity)

func _process(_delta):
	var safe = true
	var danger_amount : int = 0
	for node in get_tree().get_nodes_in_group("Npc"):
		if not node.possesed and node.global_position.distance_squared_to(player_entity.global_position) < 1500*1500:
			danger_amount += node.get_danger_level()
			if danger_amount > 0:
				safe = false 
				break
	if safe:
		get_main().music_system.set_flag("safe")
		get_main().music_system.unset_flag("battle")
	else:
		get_main().music_system.set_flag("battle")
		get_main().music_system.unset_flag("safe")


func on_ai_timeout():
	call_ai(player_entity)

#after we finish loading, allow the player to escape
func on_load(persist_objects,caller)->void:
	#make sure to wait for the game to update positions
	await get_tree().create_timer(0.5).timeout
	self.allow_escape = true
	pass

#returns a reference to the root node of the main scene
func get_main()->MainScene:
	return get_parent().get_parent()

#displays the indicated hp onto the hp display, uses the given texture 2d if one is provided
#that way different entities can have different display textures for the hp
func display_hp(
		current_hp : int,
		max_hp : int,
		heart_texture : Array[Texture2D] = [])->void:
	var main = get_main()
	if len(heart_texture) > 0:
		for i in range(len(heart_texture)):
			main.heart_tracker.heart_texture[i] = heart_texture[i]
	get_main().heart_tracker.update_display(current_hp,max_hp)
