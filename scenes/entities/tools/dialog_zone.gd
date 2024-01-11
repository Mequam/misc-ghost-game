extends Area2D

#this is a simple class that triggers a given dialog
#when the player enteres into a specified zone

class_name DialogZone


# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(self.on_body_entered)

func on_body_entered(body)->void:
	for child in get_children():
		if child is DialogComponent:
			child.next()
