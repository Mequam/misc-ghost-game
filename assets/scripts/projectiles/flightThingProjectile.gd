extends Projectile

class_name ProjectileFlightThing

var flightSplosion = load("res://scenes/animations/flightSplosion.tscn")

func gen_col_layer()->int:
	return super.gen_col_layer()
func gen_col_mask()->int:
	return super.gen_col_layer()
	

func main_ready():
	speed = 500
	print("flight thing col layer")
	print(collision_layer)
	print(collision_mask)
	print("end flight thing col")
	super.main_ready()

func on_col(collider):
	print(collider.collider.name)
	var inst = flightSplosion.instantiate()
	get_parent().add_child(inst)
	inst.global_position = global_position
	super.on_col(collider)
