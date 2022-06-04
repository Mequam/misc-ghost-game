extends Projectile

class_name WitchProjectile

# Called when the node enters the scene tree for the first time.
var magic = load("res://scenes/animations/magicParticles.tscn")
func _ready():
	var inst = magic.instance()
	inst.global_position = global_position
	get_parent().add_child(inst)
	speed = 200
	$AnimationPlayer.play("scale_up")
func on_col(collider):
	var inst = magic.instance()
	get_parent().add_child(inst)
	inst.global_position = global_position
	.on_col(collider)
