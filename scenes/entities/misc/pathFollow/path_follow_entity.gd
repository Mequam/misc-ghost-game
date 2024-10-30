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

func _process(delta)->void:
	path_follow.progress_ratio += path_velocity*path_speed_multiplier*delta/100
