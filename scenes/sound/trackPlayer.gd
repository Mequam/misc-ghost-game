extends Node

#this class represents the root of a sound tree
#where we contain all of the different tracks that we want to run

class_name SoundTree

func set_flag(flag : String)->void:
	if not (flag in flags):
		flags.append(flag)
func unset_flag(flag : String)->void:
	flags.erase(flag)

#these are the flags that the tree is using for transitions
@export var flags : Array[String]

func _ready()->void:
	$orchard.play()

func _process(_delta):
	if Input.is_action_just_pressed("JUMP"):
		self.set_flag("battle")
	if Input.is_action_just_pressed("ATTACK"):
		$Battle.volume_db = -10
