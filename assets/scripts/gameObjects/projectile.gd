extends KinColObject

class_name Projectile
var damage : int = 2

func main_ready():
	$lifeTimer.connect("timeout",Callable(self,"die"))
	collision_layer = 0
	$VisibleOnScreenNotifier2D.connect("screen_exited",Callable(self,"queue_free"))
	super.main_ready()

#it is a projectile layer
func gen_col_layer():
	return ColMath.Layer.PROJECTILES
func gen_col_mask():
	return 0

func on_col(col):
	print("COLLISION")
	if col.get_collider().has_method("take_damage"):
		col.get_collider().take_damage(damage,self)
	die()
