extends KinematicBody2D

class_name Entity

#this is the generic entity script that all
#collision game objects are inteanded to draw from

#wether or not the entity can be possesed by the player
var can_posses : bool = true
#are we possesed by the ghost?
var possesed : bool= true setget set_possesed,get_possesed
func set_possesed(val : bool)->void:
	possesed = val
func get_possesed()->bool:
	return possesed

#these two are self explanitory
var velocity : Vector2 = Vector2(0,0)
var speed : float = 50

#indicates if we are on the ground
var onground : bool = false setget set_onground,get_onground
func set_onground(val : bool)->void:
	onground = val
func get_onground()->bool:
	return onground

#stores inputs that are pressed and will remain true
#for as long as the input is not released
var pressed_inputs : Dictionary = {
	"RIGHT":false, #the first value indicates if we are pressed
	"LEFT":false, #the second value indicates if we have been double pressed
	"UP":false,
	"DOWN":false,
	"ATTACK":false,
}
#used for making new enumerators in child classes
const ENTITY_STATE_COUNT = 2
#an enumerator of entity state
enum EntityState {
	DEFAULT = 0,
	BRICK
}

#state variable used in all entities
var state : int = EntityState.DEFAULT setget set_state,get_state
func set_state(val : int)->void:
	state = val
func get_state()->int:
	return state
#used for computing double presses
var last_pressed_action : String = ""
var last_pressed_action_time : int = 0

#clears out the input store array
#useful for resetting input
func clear_stored_inputs():
	for key in pressed_inputs:
		pressed_inputs[key] = false
func main_ready():
	$GroundTester.connect("body_entered",self,"_on_GroundTester_body_entered")
	$GroundTester.connect("body_exited",self,"_on_GroundTester_body_exited")
func _ready():
	collision_layer = gen_col_layer()
	collision_mask = gen_col_mask()
#called when an action is double pressed
func on_action_double_press(action : String)->void:
	pass
#runs only when the action is just pressed
func on_action_press(action : String)->void:
	pass
#runs only when the action is released
func on_action_released(action : String)->void:
	pass
#performs the given action on the entity
#inteanded to be overloaded by the individual class
func perform_action(event : InputEvent)->void:
	for key in pressed_inputs:
		#yes this if statement is hideous, but it gaurds against
		#echo events where event.is_aciton_pressed is false
		#but we want move_right to be true
		if event.is_action_pressed(key):
			on_action_press(key)
			pressed_inputs[key] = true
			
			var current_input_time = OS.get_ticks_msec()


			if last_pressed_action == key and (current_input_time - last_pressed_action_time) < 300:
				on_action_double_press(key)

			#update the last pressed values
			last_pressed_action = key
			last_pressed_action_time = current_input_time
				
		elif event.is_action_released(key):
			pressed_inputs[key] = false
			on_action_released(key)

	if not event.is_echo():
		#only update animation on new events
		update_animation(event)
#this function is called when we are NOT possesed
#and is inteanded to feed inputs into the perform_action function
func AI()->void:
	pass

func move_and_collide(rel_vec : Vector2, 
						infinite_inertia : bool = false, 
						exclude_raycast_shapes : bool = true,
						test_only : bool = false)->KinematicCollision2D:
	var col = .move_and_collide(rel_vec,infinite_inertia,exclude_raycast_shapes,test_only)
	
	if col:
		on_col(col)

	return col
#this function is called at the end of perform_action
#and updates the animation to match the action performed
func update_animation(event : InputEvent)->void:
	pass
#called when we detect a collision
func on_col(col):
	pass

#process function that we can overload	
func main_process(delta):
	if state != EntityState.BRICK:
		move_and_collide(speed*delta*compute_velocity(velocity))

func _process(delta):
	main_process(delta)

#computes this frames velocity
func compute_velocity(child_velocity : Vector2)->Vector2:
	return child_velocity
#this is a utility function that converts an event into a direction
#in the game
func action2velocity(action : String)->Vector2:
	match action:
		"RIGHT":
			return Vector2(1,0)
		"LEFT":
			return Vector2(-1,0)
		"UP":
			return Vector2(0,-1)
		"DOWN":
			return Vector2(0,1)
	return Vector2(0,0)
	
#default collision generators
func gen_col_layer()->int:
	return ColMath.Layer.NON_PLAYER_ENTITY
func gen_col_mask()->int:
	return ColMath.Layer.TERRAIN | ColMath.ConstLayer.TILE_BORDER

func main_input(event)->void:
	#we only care about inputs if we are possesed, otherwise we
	#let the AI run
	if possesed and event.is_action_type():
		perform_action(event)

#gets the position that Leni needs to go to when he
#unposseses the entity
#defaults to the entities position if no position
#is given
func unposses_position()->Vector2:
	if $unposSpot:
		return $unposSpot.position + position
	return position

func _input(event):
	main_input(event)

func _on_GroundTester_body_entered(body):
	self.onground = true
func _on_GroundTester_body_exited(body):
	self.onground = false
