extends Area2D

#this class represents an area 2d that places focus on a given 2d node
#when the player enteres the area see the main camera script for
#exactly how this focus is goverened

class_name CameraGrabZone

#how much pull should this node get?
@export var focus_weight : float
#what node should we use to focus
@export var focus : Node2D


func get_cam_ref()->Camera2D:
	return get_parent().get_cam_ref()
func on_body_entered(body : Node2D)->void:
	if body is Entity and body.possesed:
		get_cam_ref().add_node_target(self.focus,self.focus_weight)

func on_body_exited (body : Node2D)->void:
	if body is Entity and body.possesed:
		get_cam_ref().remove_node_target(self.focus)

func _ready()->void:
	self.body_entered.connect(on_body_entered)
	self.body_exited.connect(on_body_exited)

