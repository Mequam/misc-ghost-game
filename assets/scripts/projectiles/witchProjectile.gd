extends Projectile

class_name WitchProjectile

# Called when the node enters the scene tree for the first time.
@export var magic : PackedScene 
func main_ready():
	var inst = magic.instantiate()
	inst.global_position = global_position
	get_parent().add_child(inst)
	speed = 100*Vector2.ONE
	$AnimationPlayer.play("scale_up")
	$witchProjSprite.play("default")
	
	#make sure that the previous class gets to run its ready function
	super.main_ready()
func die():
	var inst = magic.instantiate()
	get_parent().add_child(inst)
	inst.global_position = global_position
	super.die()

func on_col(collider):
	super.on_col(collider)
