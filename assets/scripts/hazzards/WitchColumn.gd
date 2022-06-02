extends Hazzard
#this is a hazard class that damages entities that enter it
#and removes itself from the tree after one animation

class_name WitchColumn

# Called when the node enters the scene tree for the first time.
func _ready():
	$WitchColumnSprite.connect("animation_finished",self,"queue_free")
