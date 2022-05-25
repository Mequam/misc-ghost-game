extends KinematicBody2D

class_name Entity

#this is the generic entity script that all
#collision game objects are inteanded to draw from
enum Actions {
	UP,
	LEFT,
	RIGHT,
	DOWN,
	ATTACK,
	DEFEND
}
#posible states that all entities have
enum State {
	IDLE,
	WALK,
	RUN
}



#indicates the state of the entity state machine
var state : int  = State.IDLE setget set_state,get_state
func set_state(val : int)->void:
	state = val
func get_state()->int:
	return state

#indicates if we are on the ground
var onground : bool = false setget set_onground,get_onground
func set_onground(val : bool)->void:
	onground = val
func get_onground()->bool:
	return onground


var velocity : Vector2 = Vector2(0,0)
var speed : float = 50

#do we listen for input from the game?
var read_input : bool= true

#performs the given action on the entity
func perform_action(act : int,pressed : bool):
	pass
	
func move_and_collide(rel_vec : Vector2, 
						infinite_inertia : bool = false, 
						exclude_raycast_shapes : bool = true,
						test_only : bool = false)->KinematicCollision2D:
	var col = .move_and_collide(rel_vec,infinite_inertia,exclude_raycast_shapes,test_only)
	if col:
		on_col(col)
	
	return col
#called when we detect a collision
func on_col(col):
	if not onground and col.normal.distance_squared_to(Vector2(0,-1)) <= 0.1:
		onground = true

func _process(delta):
	move_and_collide(speed*velocity*delta)

func _input(event):
	if read_input and event is InputEvent:
		var keys = Actions.keys()
		for i in range(0,len(keys)):
			if event.is_action_pressed(keys[i]):
				perform_action(i,true)
				break
			elif event.is_action_released(keys[i]):
				perform_action(i,false)
				break
