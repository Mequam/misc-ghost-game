extends KinColObject

class_name Projectile
func queue_free():
	print("GOODBYE WORLD")
	.queue_free()
func main_ready():
	$VisibilityNotifier2D.connect("screen_exited",self,"queue_free")
func gen_col_layer():
	return 0
func gen_col_mask():
	return 0
func on_col(col):
	queue_free()
