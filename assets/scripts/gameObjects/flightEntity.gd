extends Entity
#this is a genric entity class for entities that go up right left and down
#basically entities that can fly

class_name FlightEntity

var running : bool = true

func on_action_double_press(act : String)->void:
	if act == "LEFT" or act == "RIGHT":
		running = true
	super.on_action_double_press(act)
	
func on_action_released(act : String)->void:
	if act == "LEFT" or act == "RIGHT":
		running = false
	super.on_action_released(act)

func compute_velocity(vel : Vector2)->Vector2:
	for key in pressed_inputs:
		if pressed_inputs[key]:
			vel += action2velocity(key)
	if running:
		vel.x *= 2
	else:
		vel.y *= 1.5
	return super.compute_velocity(vel)


func update_animation()->void:
	match state:
		EntityState.DEFAULT:
			var vel : Vector2 = compute_velocity(velocity)	
			#we only change where we look when the player
			#tells us to update, not when we release
			if vel.x != 0:
				$Sprite2D.flip_h = vel.x < 0
			if vel == Vector2(0,0):
				$Sprite2D.custom_play("idle")
			elif abs(vel.y) < abs(vel.x)*2:
				if running:
					$Sprite2D.custom_play("zoom")
				else:
					$Sprite2D.custom_play("run")
			elif vel.y < 0:
				$Sprite2D.custom_play("up")
			else:
				$Sprite2D.custom_play("down")
	super.update_animation()
