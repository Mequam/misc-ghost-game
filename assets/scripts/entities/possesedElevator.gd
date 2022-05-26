extends Entity



func compute_velocity(vel : Vector2)->Vector2:
	if pressed_inputs["UP"]:
		vel.y -= 1
	else:
		vel.y += 1
		
	if pressed_inputs["DOWN"]:
		vel.y += 1
	return .compute_velocity(vel)

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 500
	possesed = false
