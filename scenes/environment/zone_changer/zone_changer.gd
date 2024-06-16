extends Area2D

class_name LevelDoor

@export var target_level : String

var used : bool = false 
@export var disabled : bool = false 
@export var do_disable_toggle : bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(on_body_entered)
	self.body_exited.connect(on_body_exited)

func on_body_exited(_body):
	disabled = disabled and not do_disable_toggle

func on_body_entered(body):
	print("someone entered me! " + self.name + "@" + get_parent().name)
	if used or disabled or not get_parent().allow_escape: return 
	used = true 
	#start the load
	GameLoader.call_deferred("load_level",load(target_level),self,[body])
