extends KinematicBody2D

#generic collision object class that all game objects
#inherit from
class_name KinColObject

#these two are self explanitory
var velocity : Vector2 = Vector2(0,0)
var speed : float = 50

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
	pass

func gen_col_layer()->int:
	return ColMath.Layer.NON_PLAYER_ENTITY
func gen_col_mask()->int:
	return ColMath.Layer.TERRAIN | ColMath.ConstLayer.TILE_BORDER

#called in the _ready class, inteanded to be overloaded
func main_ready():
	pass

func _ready():
	collision_layer = gen_col_layer()
	collision_mask = gen_col_mask()
	main_ready()

#computes this frames velocity
func compute_velocity(child_velocity : Vector2)->Vector2:
	return child_velocity

#inteanded to be overidden, runs in the process function
func main_process(delta):
	move_and_collide(speed*delta*compute_velocity(velocity))
func _process(delta):
	main_process(delta)

#not QUITE queue_free,
#intenaded to be overloaded to provide
#additional behavior ON TOP OF
#queue free in the event we still wnat
#the ability to queue_free without running the die code
func die():
	queue_free()
