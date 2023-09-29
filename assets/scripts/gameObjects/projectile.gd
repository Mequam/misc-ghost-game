extends KinColObject

class_name Projectile

@export
var damage : int = 2
@export
var terminal_velocity : int = 10

#called when we leave the screen
#simple function to remove us
func screen_exited()->void:
	queue_free()

func main_ready():
	$lifeTimer.connect("timeout",Callable(self,"die"))
	collision_layer = 0
	#make sure that we remove ourselfs from the game
	#when not visible
	$VisibleOnScreenNotifier2D.screen_exited.connect(screen_exited)
	super.main_ready()

func main_process(_delta):
	if velocity.length_squared() > 	terminal_velocity*terminal_velocity:
		velocity = velocity.normalized()*terminal_velocity
	super.main_process(_delta)

#it is a projectile layer
func gen_col_layer():
	return ColMath.Layer.PROJECTILES
func gen_col_mask():
	return 0

func on_col(col):
	if col.get_collider().has_method("take_damage"):
		col.get_collider().take_damage(damage,self)
	die()
