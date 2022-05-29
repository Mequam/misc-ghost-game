extends Npc


func compute_velocity(vel : Vector2)->Vector2:
	if pressed_inputs["UP"]:
		vel.y -= 1
	else:
		vel.y += 1
		
	if pressed_inputs["DOWN"]:
		vel.y += 1
	return .compute_velocity(vel)

func on_action_press(act):
	if act == "LEFT" and not $Sprite.flip_h:
		$Sprite.flip_h = true
	elif act == "RIGHT" and $Sprite.flip_h:
		$Sprite.flip_h = false
	elif act == "ATTACK":
		$Sprite.play("open")

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 500
	possesed = false
