extends Node

#this class represents an AI that some entity will use
#in order to perform how to move without the player

class_name EntityAI 

@export var danger_level : int = 1
@export var update_speed : float = 1


func get_level()->Level:
	var lvl = get_parent()
	while not lvl is Level:
		lvl = lvl.get_parent()
	
	return lvl

func get_player()->Entity:
	return get_level().player_entity

func _ready()->void:
	#create and set a new timer
	var t = Timer.new()
	t.wait_time = self.update_speed
	t.timeout.connect(self.timer_tick)
	add_child(t)
	t.start()

	self.caller = get_parent()

func timer_tick()->void:
	self.tick(self.get_player())
#convinence reference to the parent that is using us, we could
#make this a node, but the convinence of recourses for AI makes it easaier
#to develop in the editor, plus its minimal concideration for performance either way
var caller : Entity = null

func get_danger_level()->int:
	return danger_level

#convinence function to match the perform action in the entity class
#see entity.gd
func perform_action(act : String,
pressed : bool,
double_press : bool = false,
echo : bool = false)->void:
	#print("ENTITY AI CALLING")
	caller.perform_action(act,pressed,double_press,echo)

#convinence function that unpresses all down inputs
func release_all_inputs()->void:
	for action in caller.pressed_inputs:
		if caller.pressed_inputs[action]:
			perform_action(action,false)

#convinence function to release all inputs given in an array
func release_input_array(inputs : Array[String] )->void:
	for input in inputs:
		self.perform_action(input,false)

#this function is called when the ai wants to run
#with the player location
#see entity.gd
func tick(_player_location : Entity)->void:
	pass 

#performs a raycast to determine if we can see the player or not,
#uses entity collision mask to see if we can hit them
func can_see_player(player : Entity, visibility_distance : float = 600)->bool:
	var space_state = caller.get_world_2d().direct_space_state
	
	var look_position : Vector2 = caller.global_position
	if caller.get_node("ai_eyes"):
		look_position = caller.get_node("ai_eyes").global_position

	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(caller.global_position,
			(player.global_position - look_position).normalized()*visibility_distance,
			caller.gen_col_mask()
		)
	
	var result = space_state.intersect_ray(query)
	
	#if result:
	#	print(result["collider"].name)

	return not result.is_empty() and result["collider"] == player


#called in the entity to initilize this AI,
#again see entity.gd / _ready
func setup(caller : Entity)->void:
	self.caller = caller
