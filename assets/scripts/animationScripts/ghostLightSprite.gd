extends AnimatedSprite2D


func custom_play(anim):
	play(anim)

#we don't collide with ANYTHING
func gen_col_mask()->int:
	return 0
#we are a non player entity
func gen_col_layer()->int:
	return ColMath.Layer.NON_PLAYER_ENTITY

# Called when the node enters the scene tree for the first time.
func _ready():
	play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
