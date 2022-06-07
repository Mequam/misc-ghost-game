extends Node2D
#this script is the generic level class intenaded
#to be given to any main level node that has entity nodes as children 

class_name Level

var cam_ref : Camera2D

func _ready():
	$AITimer.connect("timeout",self,"on_ai_timeout")
func on_ai_timeout():
	if $Leni.possesed_entity:
		get_tree().call_group("Npc","run_AI",$Leni.possesed_entity)
	else:
		get_tree().call_group("Npc","AI",$Leni)
func _input(event):
	if event is InputEventKey and event.scancode == KEY_P:
		$witch.evil_possesion = $greenGhost
	elif event is InputEventKey and event.scancode == KEY_U:
		$witch.eject_evil_ghost()
