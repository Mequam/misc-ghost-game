extends Projectile

class_name WitchProjectile

# Called when the node enters the scene tree for the first time.
var magic = load("res://scenes/animations/magicParticles.tscn")
func _ready():
	var inst = magic.instantiate()
	inst.global_position = global_position
	get_parent().add_child(inst)
	speed = 100
	$AnimationPlayer.play("scale_up")
func die():
	var inst = magic.instantiate()
	get_parent().add_child(inst)
	inst.global_position = global_position
	super.die()

func on_col(collider):
	super.on_col(collider)
