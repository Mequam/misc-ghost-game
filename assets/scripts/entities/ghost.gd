extends Entity
#this class represents the player ghost
#that posseses stuff

class_name Leni


enum LeniState {
	POSSESING = ENTITY_STATE_COUNT
}

var running : bool = true
#we can only fly for so long before we get tired
var tired : bool = false

#saved velocity for the possession attack
var posses_velocity : Vector2 = Vector2(0,0)

func _ready():
	#the ghost allways recives player input
	#unless parralized, so it is "possesed"
	possesed = true
	speed = 150

func set_onground(val : bool)->void:
	if not onground and val:
		tired = false
		$flight_timer.stop()
	if not val:
		$flight_timer.start()
	update_animation()
	.set_onground(val)

func on_action_double_press(act : String)->void:
	if act == "LEFT" or act == "RIGHT":
		running = true
	.on_action_double_press(act)
func on_action_released(act : String)->void:
	if act == "LEFT" or act == "RIGHT":
		running = false
	.on_action_released(act)
func on_action_press(act : String)->void:
	print("action press! " + act)
	if act == "ATTACK":
		posses_attack(compute_velocity(velocity).normalized()*10)
	.on_action_press(act)

#runs whenever state is set and ensures the
#state machine functions properly
func set_state(val : int)->void:
	match val:
		LeniState.POSSESING:
			print("starting timer")
			$posses_timer.start()
			$ghostSprite.play("posses_launch")
	.set_state(val)

#launch ourselfs and prepare to posses
func posses_attack(vel : Vector2)->void:
	print("calling pos attack")
	if vel.x != 0:
		print("attacking!")
		posses_velocity = vel
		posses_velocity.y /= 2
		clear_stored_inputs()
		self.state = LeniState.POSSESING
		

#actually posses an entity
func posses(entity)->void:
	possesed = false
	entity.possesed = true

func compute_velocity(vel : Vector2)->Vector2:
	match state:
		EntityState.DEFAULT:
			for key in pressed_inputs:
				if pressed_inputs[key]:
					vel += action2velocity(key)
				if running:
					vel *= 1.3
			if tired:
				vel.y += 1.2
			else:
				vel.y *= 1.5
		LeniState.POSSESING:
			vel = posses_velocity
	return .compute_velocity(vel)

func perform_action(event : InputEvent)->void:
	match state:
		LeniState.POSSESING:
			#while we are possesing we do NOT
			#update player input
			pass
		_:
			.perform_action(event)

func update_animation(event : InputEvent = null)->void:
	match state:
		EntityState.DEFAULT:
			var vel : Vector2 = compute_velocity(velocity)	
			#we only change where we look when the player
			#tells us to update, not when we release
			if vel.x != 0:
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



func _on_flight_timer_timeout():
	tired = true


func _on_posses_timer_timeout():
	posses_velocity = Vector2(0,0)
	$ghostSprite.play("posses_end")
	
func _on_ghostSprite_animation_finished():
	state = EntityState.DEFAULT
