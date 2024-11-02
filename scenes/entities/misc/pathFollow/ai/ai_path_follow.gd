extends EntityAI

# this script is an ai for the line follow entity
# that makes it move along a path and then back
# and again and again and again

class_name AIPathFollowBackForth

@export var flip_error : float = 0.01
func _ready() -> void:
	super._ready()
	self.caller.perform_action("RIGHT",true)

func get_path_follow()->PathFollow2D:
	return self.caller.get_parent()

func tick(_player_location : Entity) -> void:
	
	if self.caller.path_velocity == 0:
		self.caller.perform_action("RIGHT",false)
		self.caller.perform_action("LEFT",false)

		self.caller.perform_action("LEFT",true)

	if self.get_path_follow().progress_ratio > 1 - flip_error:
		self.caller.perform_action("RIGHT",false)
		self.caller.perform_action("LEFT",true)
	elif self.get_path_follow().progress_ratio < 0 + flip_error:
		self.caller.perform_action("LEFT",false)
		self.caller.perform_action("RIGHT",true)
	
