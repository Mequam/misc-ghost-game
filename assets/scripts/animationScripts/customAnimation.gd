extends AnimatedSprite2D
#this class is a place to put custom animation
#that the sprite 2D can use for chaining
class_name CustomAnimationChain


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func custom_play(anim : StringName = "idle",val : bool=false)->void:
	play(anim,1,val)
