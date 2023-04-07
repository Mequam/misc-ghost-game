extends CharacterBody2D

#generic collision object class that all game objects
#inherit from
class_name KinColObject

#these two are self explanitory

var speed : float = 50


func singal_move_and_collide(rel_vec : Vector2,test_only : bool = false,sm : float = 0.08,test : bool = false)->KinematicCollision2D:
	var col = move_and_collide(rel_vec,test_only,sm,test)
		
	if col:
		on_col(col)
		rel_vec -= rel_vec.project(col.get_normal())
		move_and_collide(rel_vec,test_only,sm,test)

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
	singal_move_and_collide(speed*delta*compute_velocity(velocity))

func _process(delta):
	main_process(delta)

#not QUITE queue_free,
#intenaded to be overloaded to provide
#additional behavior ON TOP OF
#queue free in the event we still wnat
#the ability to queue_free without running the die code
func die():
	queue_free()
