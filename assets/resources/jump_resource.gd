extends Resource

class_name JumpResource

@export var jump_height : float
@export var jump_up_time : float
@export var jump_down_time : float

#returns the gravity that we need to be pulled at if we want
#to stop at the given height in the given time
func get_gravity(height,time)->float:
	return height/(time*time)
#returns the speed that we need to start at if we want to travel
#to the given height in the given time
func get_initial_speed(height,time)->float:
	return 2*height/time

#returns the gravity for the upwords portion of our jump
func get_up_gravity()->float:
	return get_gravity(jump_height,jump_up_time)
#returns the initial speed we need to move at for our upwords jump
func get_initial_up_speed()->float:
	return get_initial_speed(jump_height,jump_up_time)
#returns the gravity for the downwards portion of our jump
func get_down_gravity()->float:
	return get_gravity(jump_height,jump_down_time)
