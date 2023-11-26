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

#plays the first available song 
func play(name = null)->void:
	if name == null:
		get_child(0).play()
	else:
		get_node(name).play()

