extends Resource

#this class represents the code needed to move
#to a target position given a navigation point from
#a nav_agent inside of the nav_routine resource

class_name AINavigationFollowTechnique

var parent_resource : SubAINavigationStraight

@export var closeness_threshold : float = 50
@export var move_threshold : Vector2 = Vector2(10,10)
@export var sprint_threshold : Vector2 = Vector2(100,100)
@export var collision_bias_weight : float = 50

var bias : Vector2

func stop_moving():
	if parent_resource.caller.pressed_inputs["LEFT"]:
		parent_resource.perform_action("LEFT",false)
	if parent_resource.caller.pressed_inputs["RIGHT"]:
		parent_resource.perform_action("RIGHT",false)

	var next_pos : Vector2 = parent_resource.nav_agent.get_next_path_position()

	if parent_resource.caller.pressed_inputs["UP"] and (parent_resource.caller.onground or
													(next_pos.y-parent_resource.caller.position.y) > 50):
		parent_resource.perform_action("UP",false)
	if parent_resource.caller.pressed_inputs["DOWN"]:
		parent_resource.perform_action("DOWN",false)


func move_to_point(point : Vector2)->void:
	var delta = point - parent_resource.caller.global_position 
	
	stop_moving()

	if delta.length_squared() <= closeness_threshold:
		print_debug("too close, not moving")
		return
	
	#only account for the bias after checking if we should move
	delta += bias

	#print_debug("moving")

	if abs(delta.x) > move_threshold.x:
		var dir = "RIGHT"
		if delta.x < 0:
			dir = "LEFT"
		parent_resource.perform_action(dir,true,abs(delta.x) > sprint_threshold.x)
	
	if abs(delta.y) > move_threshold.y:
		var dir = "DOWN"
		if delta.y < 0:
			dir = "UP"
		parent_resource.perform_action(dir,true,abs(delta.y) > sprint_threshold.y)
	
	bias *= 0.9 #shrink the bias


var last_collision_position : Vector2 = Vector2(0,0)
func caller_collided(col):
	if parent_resource.caller.global_position.distance_squared_to(last_collision_position) < 10:
		var normal : Vector2 = col.get_normal()
		var target_direction = (parent_resource.last_target_position-parent_resource.caller.global_position).normalized()
		print(target_direction.dot(normal))
		if target_direction.dot(normal) < -0.1:
			bias = -target_direction*collision_bias_weight
	
	last_collision_position = parent_resource.caller.global_position
