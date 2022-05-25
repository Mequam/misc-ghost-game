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
