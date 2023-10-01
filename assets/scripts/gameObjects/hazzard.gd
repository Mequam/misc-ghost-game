extends Area2D
#a hazard is an area2d that damages, slows, or otherwise interacts 
#with entities that enter it
class_name Hazzard

func gen_col_layer()->int:
	return ColMath.Layer.HAZARD
func gen_col_mask()->int:
	return ColMath.Layer.NON_PLAYER_ENTITY | ColMath.ConstLayer.PLAYER

#called in the _ready class, inteanded to be overloaded
func main_ready():
	self.connect("body_entered",Callable(self,"on_body_entered"))
	self.connect("body_exited",Callable(self,"on_body_exited"))

func on_body_entered(body):
	print("hazard hit!")
	if body.has_method("take_damage"):
		body.take_damage()

func on_body_exited(body):
	pass

func _ready():
	collision_layer = gen_col_layer()
	collision_mask = gen_col_mask()
	main_ready()
