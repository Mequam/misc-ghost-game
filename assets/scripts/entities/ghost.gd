extends Entity
#this class represents the player ghost
#that posseses stuff

class_name Leni

#default collision layer for Leni
func gen_col_layer()->int:
	return ColMath.Layer.PLAYER | ColMath.ConstLayer.PLAYER
func gen_col_mask()->int:
	return ColMath.Layer.NON_PLAYER_ENTITY | .gen_col_mask() 
enum LeniState {
	POSSESING = ENTITY_STATE_COUNT #we are activly attempting to posses somthing
}

var running : bool = true
#we can only fly for so long before we get tired
var tired : bool = false setget set_tired,get_tired
func set_tired(val : bool)->void:
	tired = val
	update_animation()
func get_tired()->bool:
	return tired
#saved velocity for the possession attack
var posses_velocity : Vector2 = Vector2(0,0)
#reference to the entity we are currently possesing
var possesed_entity : Entity = null

func main_ready():
	#the ghost allways recives player input
	#unless parralized, so it is "possesed"
	possesed = true
	speed = 400
	(get_parent() as Level).cam_ref = $mainCam
	.main_ready()
	

func set_onground(val : bool)->void:
	if not onground and val:
		tired = false
		$flight_timer.stop()
	if not val:
		$flight_timer.start()
	update_animation()
	.set_onground(val)

func on_action_double_press(act : String)->void:
	print("DOUBLE PRESS " + act)
	if act == "LEFT" or act == "RIGHT":
		running = true
	elif act == "UP" and not possesed:
		unposses()
	.on_action_double_press(act)
func on_action_released(act : String)->void:
	if act == "LEFT" or act == "RIGHT":
		running = false
	.on_action_released(act)
func on_action_press(act : String)->void:
	if act == "ATTACK":
		posses_attack(compute_velocity(velocity).normalized()*5)
	.on_action_press(act)

func set_possesed(val : bool)->void:
	if not possesed and val:
		visible = true
		collision_layer = gen_col_layer()
		collision_mask = gen_col_mask()
		state = EntityState.DEFAULT
		$mainCam.position = Vector2(0,0)
	elif not val:
		$ghostSprite.stop()
		visible = false
		collision_layer = 0
		collision_mask = 0

	.set_possesed(val)
#runs whenever state is set and ensures the
#state machine functions properly
func set_state(val : int)->void:
	match val:
		LeniState.POSSESING:
			$posses_timer.start()
			$ghostSprite.play("posses_launch")
		LeniState.POSSESING_ENTITY:
			#make us unexist
			visible = false
			collision_layer = 0
			collision_mask = 0

	.set_state(val)

#launch ourselfs and prepare to posses
func posses_attack(vel : Vector2)->void:
	if vel.x != 0:
		posses_velocity = vel
		posses_velocity.y /= 2
		clear_stored_inputs()
		self.state = LeniState.POSSESING
#clears our possesion	
func unposses()->void:
	if possesed_entity:
		possesed_entity.possesed = false
	self.possesed = true
	
	position = possesed_entity.unposses_position()
	possesed_entity = null
	
	$ghostSprite.emit_ectosplosion()

#actually posses an entity
func posses(entity)->void:
	#swap the possesion around
	self.possesed = false
	entity.possesed = true
	
	#save a reference to the possesed entity
	possesed_entity = entity


func compute_velocity(vel : Vector2)->Vector2:
	if not possesed:
		return Vector2(0,0)
		
	match state:
		EntityState.DEFAULT:
			for key in pressed_inputs:
				if pressed_inputs[key]:
					vel += action2velocity(key)
			if running:
				vel.x *= 2
			if tired:
				vel.y += 1.2
			else:
				vel.y *= 1.5
		LeniState.POSSESING:
			vel = posses_velocity
	return .compute_velocity(vel)

func compute_action(event : InputEvent)->void:
	match state:
		LeniState.POSSESING:
			#while we are possesing we do NOT
			#update player input
			pass
		_:
			.compute_action(event)

func update_animation()->void:
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
	.update_animation()

func main_process(delta):
	#Leni does NOTHING if he is not possesed
	if possesed:
		.main_process(delta)
	if possesed_entity:
		$mainCam.global_position = possesed_entity.global_position

#overload the usual input
#because Leni ALWAYS listens to input
func main_input(event)->void:
	compute_action(event)

func on_col(col)->void:
	match state:
		LeniState.POSSESING:
			if abs(col.normal.x) > abs(col.normal.y):
				state = EntityState.BRICK
				possesed_entity = col.collider
				$ghostSprite.play("posses_col")
	.on_col(col)

func _on_flight_timer_timeout():
	self.tired = true

func _on_posses_timer_timeout():
	posses_velocity = Vector2(0,0)
	if state != EntityState.BRICK:
		$ghostSprite.play("posses_end")

func _on_ghostSprite_animation_finished():
	match $ghostSprite.animation:
		"posses_col":
			posses(possesed_entity)
		"posses":
			pass
		"posses_launch":
			pass
		_:
			state = EntityState.DEFAULT
