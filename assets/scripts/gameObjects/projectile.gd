extends KinColObject

class_name Projectile
var damage : int = 2

func queue_free():
	.queue_free()
func main_ready():
	collision_mask = ColMath.Layer.PLAYER
	collision_layer = 0
	$VisibilityNotifier2D.connect("screen_exited",self,"queue_free")
func gen_col_layer():
	return 0
func gen_col_mask():
	return 0
func on_col(col):
	print("COLLISION")
	if col.collider.has_method("take_damage"):
		col.collider.take_damage(damage,self)
	queue_free()
