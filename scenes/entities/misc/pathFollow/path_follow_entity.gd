extends Entity

# this is a simple entity class that follows a godot
# path on left or right

class_name PathFollowEntity

# speed multiplier in hundredths
@export var path_speed_multiplier : float = 1.0
# the path follow that we change the progress of
@export var path_follow : PathFollow2D = null

func _ready() -> void:
	if path_follow == null:
		path_follow = get_parent()
	super._ready()


#gets the direction that the player wants to move in
func get_desired_direction()->float:
	#as much as I hate to use different code for possesion and unpossesion
	#it will be WILDLY easier if we map player chords to local space and leave
	#AI cords in global space
	if self.possesed:
		return self.path_follow.global_transform.basis_xform_inv(
		self.get_pressed_direction()
		).x
	return self.get_pressed_direction().x

func _process(delta)->void:
	path_follow.progress_ratio += self.get_desired_direction()*path_speed_multiplier*delta/100
	

	if path_follow.progress_ratio < 0:
		path_follow.progress_ratio = 0
	elif path_follow.progress_ratio > 1:
		path_follow.progress_ratio = 1
