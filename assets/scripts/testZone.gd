extends Node2D
#this script is the generic level class intenaded
#to be given to any main level node that has entity nodes as children 

class_name Level

var cam_ref : Camera2D :
	get:
		return cam_ref # TODOConverter40 Copy here content of get_cam_ref
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_cam_ref
func set_cam_ref(ref : Camera2D)->void:
	cam_ref = ref
	set_cam_limit()
func get_cam_ref()->Camera2D:
	return cam_ref
var cam_limit_left = -908
func set_cam_limit()->void:
	cam_ref.limit_left = -908
	cam_ref.limit_right = 828
	cam_ref.limit_bottom = 192

#level data loaded in from the disc when we load this level
var level_data : Dictionary

func _ready():
	$AITimer.connect("timeout",Callable(self,"on_ai_timeout"))
	($Leni/mainCam as Camera2D).limit_left = cam_limit_left

func call_ai(aggro_entity):
	get_tree().call_group("Npc","run_AI",aggro_entity)
	get_tree().call_group("EvilGhost","run_AI",aggro_entity)

func _process(delta):
	if Input.is_key_pressed(KEY_P):
		print($Leni.onground)

func on_ai_timeout():
	if $Leni.possesed_entity:
		call_ai($Leni.possesed_entity)
	else:
		call_ai($Leni)
