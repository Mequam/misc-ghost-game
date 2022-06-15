extends Projectile

class_name WitchProjectile

# Called when the node enters the scene tree for the first time.
var magic = load("res://scenes/animations/magicParticles.tscn")
func _ready():
	var inst = magic.instance()
	inst.global_position = global_position
	get_parent().add_child(inst)
	speed = 100
	$AnimationPlayer.play("scale_up")
func die():
	var inst = magic.instance()
	get_parent().add_child(inst)
	inst.global_position = global_position
	.die()

func on_col(collider):
	.on_col(collider)
