extends Hazzard
#this is a hazard class that damages entities that enter it
#and removes itself from the tree after one animation

class_name WitchColumn
@export var magic_particles : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.collision_mask)
	var mp = magic_particles.instantiate()
	mp.global_position = global_position+Vector2(0,20)
	get_parent().add_child(mp)
	$WitchColumnSprite.connect("animation_finished",Callable(self,"queue_free"))
	$WitchColumnSprite.play("default")
