extends KinColObject

class_name Projectile
var damage : int = 2

func queue_free():
	.queue_free()
func main_ready():
	$lifeTimer.connect("timeout",self,"die")
	collision_layer = 0
	$VisibilityNotifier2D.connect("screen_exited",self,"queue_free")
	.main_ready()

#it is a projectile layer
func gen_col_layer():
	return ColMath.Layer.PROJECTILES
func gen_col_mask():
	return 0

func on_col(col):
	print("COLLISION")
	if col.collider.has_method("take_damage"):
		col.collider.take_damage(damage,self)
	die()
