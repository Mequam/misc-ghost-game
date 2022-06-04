extends Npc

class_name LRJEntity #Left Right Jump Entity

#this is a class of entity that is moved around ising left right and jump

#how fast we fall to the ground
var gravity : float = speed/2
var run : bool = false #wether or not we are running
var run_modifier : float = 4

func main_ready():
	speed = 100
	self.onground = false
	.main_ready()
func set_onground(val : bool)->void:
	if val:
		self.velocity.y = 0
	.set_onground(val)
func on_action_double_press(act : String)->void:
	if act == "LEFT" or act == "RIGHT":
		run = true
	.on_action_double_press(act)
func on_action_released(act : String)->void:
	if act == "LEFT" or act == "RIGHT":
		run = false
	.on_action_released(act)
func on_action_press(act : String)->void:
	match act:
		"JUMP":
			if onground:
				self.velocity = Vector2(0,-9)
				$Sprite.play("jump")
			
	.on_action_press(act)
func compute_velocity(velocity : Vector2)->Vector2:
	if pressed_inputs["RIGHT"]:
		velocity += Vector2(1,0)
	if pressed_inputs["LEFT"]:
		velocity -= Vector2(1,0)
	if run:
		velocity.x *= run_modifier
	return .compute_velocity(velocity)

func update_animation(event : InputEvent)->void:
	var computed_vel : Vector2 = compute_velocity(velocity)
	print(computed_vel.x)
	if computed_vel == Vector2(0,0):
		$Sprite.play("idle")
	elif computed_vel.y > 0:
		$Sprite.play("fall_start")
	elif onground and not pressed_inputs["JUMP"] and abs(computed_vel.x) > 0:
		$Sprite.play("walk_right")
	
	if $Sprite.animation != "idle":
		$Sprite.flip_h = computed_vel.x < 0
	
	.update_animation(event)

#we fall when we are in the air
func main_process(delta):
	if not onground and not state == EntityState.BRICK:
		velocity.y += gravity*delta
	.main_process(delta)
