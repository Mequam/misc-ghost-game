extends Entity
#this class represents the player ghost
#that posseses stuff

class_name PlayerGhost

var running : bool = true

func _ready():
	#the ghost allways recives player input
	#unless parralized, so it is "possesed"
	possesed = true
	speed = 100

func on_action_double_press(act : String)->void:
	if act == "LEFT" or act == "RIGHT":
		running = true
	.on_action_double_press(act)
func on_action_released(act : String)->void:
	if act == "LEFT" or act == "RIGHT":
		running = false
	.on_action_released(act)

func compute_velocity(vel : Vector2)->Vector2:
	for key in pressed_inputs:
		if pressed_inputs[key]:
			vel += action2velocity(key)
		if running:
			vel *= 1.3
	return .compute_velocity(vel)

func perform_action(event : InputEvent)->void:
	.perform_action(event)

func update_animation(event : InputEvent)->void:
	var vel : Vector2 = compute_velocity(velocity)	
	#we only change where we look when the player
	#tells us to update, not when we release
	if event.is_pressed():
		$ghostSprite.flip_h = vel.x < 0
	if vel == Vector2(0,0):
		$ghostSprite.play("idle")
	elif abs(vel.y) < abs(vel.x):
		if running:
			$ghostSprite.play("zoom")
		else:
			$ghostSprite.play("run")
	elif vel.y < 0:
		$ghostSprite.play("up")
	else:
		$ghostSprite.play("down")
	
	.update_animation(event)
