extends TiredFlightEntity
#this class represents the player ghost
#that posseses stuff

class_name Leni
#the hp that the player starts with, saved for when we die
export var start_hp : int = 5

#resets the player health for the level
#as well as doing any other action that needs to be done
#on health reset
func reset_health()->void:
	health = start_hp

#a reference to the lamp that we respawn at
var respawn_point : RespawnLamp

func die()->void:
	print("dieing!")
	emit_signal("die")
	reset_health()
	print(health)
	posses(respawn_point)

	
#default collision layer for Leni
func gen_col_layer()->int:
	return ColMath.Layer.PLAYER | ColMath.ConstLayer.PLAYER
func gen_col_mask()->int:
	return ColMath.Layer.NON_PLAYER_ENTITY | .gen_col_mask()
enum LeniState {
	POSSESING = Entity.ENTITY_STATE_COUNT,
	POSSESING_ENTITY #we are activly attempting to posses somthing
}
#saved velocity for the possession attack
var posses_velocity : Vector2 = Vector2(0,0)
#reference to the entity we are currently possesing
var possesed_entity : Entity = null

func main_ready():
	#the ghost allways recives player input
	#unless parralized, so it is "possesed"
	possesed = true
	speed = 200
	(get_parent() as Level).cam_ref = $mainCam
	.main_ready()

func on_action_double_press(act : String)->void:
	if act == "UP":
		unposses()
	.on_action_double_press(act)
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
		$Sprite.stop()
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
			$Sprite.play("posses_launch")
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
		possesed_entity.collision_layer = possesed_entity.gen_col_layer()
		possesed_entity.collision_mask = possesed_entity.gen_col_mask()
		possesed_entity.state = EntityState.DAZED
	
	
		global_position = possesed_entity.unposses_position()
		possesed_entity.disconnect("die",self,"on_possesed_die")
		$Sprite.emit_ectosplosion()
		
	possesed_entity = null
	self.possesed = true
#convinence function that saves the game at the given ghost light
func save_at_light(ghostLight : RespawnLamp)->void:
	print("saving at a ghost light")
	SaveUtils.save_game(Globals.game_name,
						get_parent(),
						ghostLight)
#actually posses an entity
func posses(entity)->void:
	#clear out the existing possesed entity
	if possesed_entity:
		unposses()
	#swap the possesion around
	self.possesed = false
	entity.possesed = true	
	if (entity is RespawnLamp):
		respawn_point = entity
		save_at_light(entity)
	else:
		#update the collision layer and mask of the entity
		entity.collision_layer = ColMath.strip_bits(entity.collision_layer,ColMath.Layer.NON_PLAYER_ENTITY)
		entity.collision_layer |= ColMath.Layer.PLAYER
	
		#update the collision mask of the entity
		entity.collision_mask = ColMath.strip_bits(entity.collision_mask,ColMath.Layer.PLAYER)
		entity.collision_mask |= ColMath.Layer.NON_PLAYER_ENTITY
	
	#save a reference to the possesed entity
	possesed_entity = entity
	possesed_entity.connect("die",self,"on_possesed_die")

func compute_velocity(vel : Vector2)->Vector2:	
	if not possesed:
		return Vector2(0,0)
	match state:
		EntityState.DEFAULT:
			return .compute_velocity(vel)
		LeniState.POSSESING:
			return posses_velocity
	
	#just in case
	return .compute_velocity(vel)

func compute_action(event : InputEvent)->void:
	match state:
		LeniState.POSSESING:
			#while we are possesing we do NOT
			#update player input
			pass
		_:
			.compute_action(event)

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
			if (col.collider is Entity) and (abs(col.normal.x) > abs(col.normal.y)):
				state = EntityState.BRICK
				possesed_entity = col.collider
				$Sprite.play("posses_col")
	.on_col(col)

func _on_posses_timer_timeout():
	posses_velocity = Vector2(0,0)
	if state != EntityState.BRICK:
		$Sprite.play("posses_end")

func _on_ghostSprite_animation_finished():
	match $Sprite.animation:
		"posses_col":
			posses(possesed_entity)
		"posses":
			pass
		"posses_launch":
			pass
		_:
			state = EntityState.DEFAULT
func on_possesed_die():
	unposses()
