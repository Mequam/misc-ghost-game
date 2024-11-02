extends Entity

# this is a simple entity class that follows a godot
# path on left or right

class_name PathFollowEntity

# speed multiplier in hundredths
@export var path_speed_multiplier : float = 1.0
# the path follow that we change the progress of
@export var path_follow : PathFollow2D = null

#current speed we are moving
var path_velocity : float = 0.0

func _ready() -> void:
	if path_follow == null:
		path_follow = get_parent()
	super._ready()

func on_action_press(act : String)->void:
	var direction = action2velocity(act)
	path_velocity += direction.x
	super.on_action_press(act)

func on_action_released(act : String)->void:
	var direction = action2velocity(act)
	path_velocity -= direction.x
	super.on_action_released(act)

#just to be safe zero out the path velocity between possesion
func posess_by(entity)->void:
	super.posses_by(entity)
	self.path_velocity = 0

func exorcize(offset : Vector2 = Vector2(0,0))->void:
	super.exorcize(offset)
	self.path_velocity = 0
	self.clear_stored_inputs()

func _process(delta)->void:
	path_follow.progress_ratio += path_velocity*path_speed_multiplier*delta/100
	

	if path_follow.progress_ratio < 0:
		path_follow.progress_ratio = 0
	elif path_follow.progress_ratio > 1:
		path_follow.progress_ratio = 1
	
	# this is NOT the correct way to do this, but it works
	# and deals with legacy input systems that could
	# probably be better designed
	if abs(path_velocity) > 1:
		path_velocity = abs(path_velocity) / path_velocity
