extends EntityAI

#this ai moves straight twoards the first target in a path via navigation

class_name SubAINavigationStraight

@export var update_target_threshold : float = 10
@export var follow_technique : AINavigationFollowTechnique

var last_target_position : Vector2 = Vector2(0,0)
var nav_agent : NavigationAgent2D = null

@export_flags_2d_navigation var navigation_layers : int = 1

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


func tick(_player : Entity)->void:
	#print_debug(nav_agent.get_next_path_position())
	#print_debug(nav_agent.get_current_navigation_result().path)
	var current_target : Vector2 = nav_agent.get_next_path_position()
	follow_technique.move_to_point(current_target)

		


func setup(caller : Entity)->void:
	super.setup(caller)
	
	#set up the navigation
	nav_agent = NavigationAgent2D.new()
	nav_agent.navigation_layers = navigation_layers
	caller.add_child(nav_agent)
	caller.sig_on_col.connect(follow_technique.caller_collided)

	follow_technique.parent_resource = self
