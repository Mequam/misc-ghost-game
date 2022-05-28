extends AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


var ghost_run_counter : int = 0

#how high up and down we go when running
var turbulance : float = 5
#up is a boolean that determines if the sprite is 
#elevated by turbulance from start position
var up : bool = false setget set_up,get_up

func play(anim : String = "",backwords : bool = false)->void:
	position = Vector2(0,0)
	match anim:
		"posses_launch":
			speed_scale = 5
		"posses_end":
			position = Vector2(55,0) if flip_h	else Vector2(-55,0) 
			speed_scale = 2.5
		_:
			speed_scale = 1.5
	.play(anim,backwords)

func set_up(val : bool)->void:
	if val:
		position = Vector2(0,turbulance)
	else:
		position = Vector2(0,0)
	up = val
func get_up()->bool:
	return up

func _on_ghostSprite_frame_changed():
	if animation == "run" and ghost_run_counter == 2:
		self.up = !up
		ghost_run_counter = -1
	ghost_run_counter += 1


func _on_ghostSprite_animation_finished():
	match animation:
		"posses_launch":
			play("posses")
		"posses_end":
			play("idle")
