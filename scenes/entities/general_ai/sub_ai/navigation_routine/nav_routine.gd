extends EntityAI

#this ai moves straight twoards the first target in a path via navigation

class_name SubAINavigationStraight

@export var closeness_threshold : float = 50
@export var sprint_threshold : Vector2 = Vector2(0,0)
@export var move_threshold : Vector2 = Vector2(10,10)
@export var update_target_threshold : float = 10
@export var collision_bias_weight : float = 50


var bias : Vector2 = Vector2(0,0)
var last_target_position : Vector2 = Vector2(0,0)
var nav_agent : NavigationAgent2D = null

func set_target(target_position : Vector2)->void:
	if target_position.distance_squared_to((last_target_position)) <= update_target_threshold: return
	nav_agent.target_position = target_position

#convinence function to stop us from moving
func stop_moving():
	if caller.pressed_inputs["LEFT"]:
		perform_action("LEFT",false)
	if caller.pressed_inputs["RIGHT"]:
		perform_action("RIGHT",false)

	var next_pos : Vector2 = nav_agent.get_next_path_position()

	if caller.pressed_inputs["UP"] and (caller.onground or
													(next_pos.y-caller.position.y) > 50):
		perform_action("UP",false)
	if caller.pressed_inputs["DOWN"]:
		perform_action("DOWN",false)

func move_to_point(point : Vector2)->void:
	var delta = point - caller.global_position 
	
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
		perform_action(dir,true,abs(delta.x) > sprint_threshold.x)
	
	if abs(delta.y) > move_threshold.y:
		var dir = "DOWN"
		if delta.y < 0:
			dir = "UP"
		perform_action(dir,true,abs(delta.y) > sprint_threshold.y)
	
	bias *= 0.9 #shrink the bias

func tick(player : Entity)->void:
	#print_debug(nav_agent.get_next_path_position())
	#print_debug(nav_agent.get_current_navigation_result().path)
	var current_target : Vector2 = nav_agent.get_next_path_position()

	move_to_point(current_target)
	last_target_position = current_target

var last_collision_position : Vector2 = Vector2(0,0)
func caller_collided(col):
	if caller.global_position.distance_squared_to(last_collision_position) < 10:
		var normal : Vector2 = col.get_normal()
		var target_direction = (last_target_position-caller.global_position).normalized()
		print(target_direction.dot(normal))
		if target_direction.dot(normal) < -0.1:
			bias = -target_direction*collision_bias_weight
	
	last_collision_position = caller.global_position
		


func setup(caller : Entity)->void:
	super.setup(caller)
	#set up the navigation
	nav_agent = NavigationAgent2D.new()
	caller.add_child(nav_agent)
	caller.sig_on_col.connect(caller_collided)

