extends TiredFlightEntity
#this class represents the player ghost
#that posseses stuff

class_name Leni

#the hp that the player starts with, saved for when we die
@export var start_hp : int = 5

@export var invensible_timer : Timer

#resets the player health for the level
#as well as doing any other action that needs to be done
#checked health reset
func reset_health()->void:
	health = start_hp

#a reference to the lamp that we respawn at
var respawn_point : RespawnLamp


@export
var ghost_after_effect : GhostAfterEffectNode

#simple conviennce function to store the current
#entity as one the game should target
func store_aggro(host):
	get_parent().player_entity = host 

#leni dies AFTER we finish the die animation
#so hijak die and call super.die when the anim finishes
func die():
	$Sprite2D.custom_play("die")

#convinence function to ensure that we are the object
#that the game targets
func grab_aggro():
	store_aggro(self)
func take_damage(dmg : int = 1, src = null)->void:
	if invensible_timer.time_left <= 0 and self.get_sprite2D().animation != "posses": #we take no damage while possesing
		super.take_damage(dmg,src)

func on_unpos_buff_timer_stop():
	super.on_ground_changed(0) #indicate that we need to check if we are flying

#called on the entity we exorcize when removing it
func on_unposses(host)->void:
	self.state = EntityState.DEFAULT
	grab_camera()
	grab_aggro() #ensure that leni is targeted
	invensible_timer.start()

	self.tired = false #we get fly even higher after coming out of possesion
	
	$unpos_buff_timer.start() #we get buffed for a time after we posses something
	
	super.on_unposses(host)

func on_posses(host)->void:
	store_aggro(host) #ensure that we are the targeted entity
	
#default collision layer for Leni
func gen_col_layer()->int:
	return ColMath.Layer.PLAYER | ColMath.ConstLayer.PLAYER
func gen_col_mask()->int:
	return (ColMath.Layer.PICKUP | ColMath.Layer.NON_PLAYER_ENTITY | super.gen_col_mask()) & ~ColMath.Layer.PLAYER
enum LeniState {
	POSSESING = Entity.ENTITY_STATE_COUNT,
	POSSESING_ENTITY #we are activly attempting to posses somthing
}
#saved velocity for the possession attack
var posses_velocity : Vector2 = Vector2(0,0)

func main_ready():
	#the ghost allways recives player input
	#unless parralized, so it is "possesed"
	grab_camera()
	super.main_ready()

	possesed = true #make sure we start as possesed
	$unpos_buff_timer.timeout.connect(self.on_unpos_buff_timer_stop)


func on_action_press(act : String)->void:
	if act == "ATTACK":
		posses_attack(compute_velocity(velocity).normalized()*5)
	super.on_action_press(act)

#func set_possesed(val : bool)->void:
#	if not possesed and val:
#		visible = true
#		collision_layer = gen_col_layer()
#		collision_mask = gen_col_mask()
#		state = EntityState.DEFAULT
#		$mainCam.position = Vector2(0,0)
#	elif not val:
#		$Sprite2D.stop()
#		visible = false
#		collision_layer = 0
#		collision_mask = 0
#
#	super.set_possesed(val)

#runs whenever state is set and ensures the
#state machine functions properly
func set_state(val : int)->void:
	match val:
		LeniState.POSSESING:
			$posses_timer.start()
			$Sprite2D.custom_play("posses_launch")
		LeniState.POSSESING_ENTITY:
			#make us unexist
			visible = false
			collision_layer = 0
			collision_mask = 0

	super.set_state(val)

#launch ourselfs and prepare to posses
func posses_attack(vel : Vector2)->void:
	if vel.x != 0:
		posses_velocity = vel
		posses_velocity.y /= 2
		clear_stored_inputs()
		self.state = LeniState.POSSESING

#leni is a ghost, you cant posses a ghost (at least until I get around to adding it :p)
func exorcize():
	pass
func posses_by(entity):
	pass


#convinence function that saves the game at the given ghost light
func save_at_light(ghostLight : RespawnLamp)->void:
	SaveUtils.save_game(Globals.game_name,
						get_parent(),
						ghostLight)

#actually posses an entity
#func posses(entity)->void:
#
#	#clear out the existing possesed entity
#	if possesed_entity:
#		unposses()
#	
#	#swap the possesion around
#	self.possesed = false
#	entity.possesed = true
#
#	ghost_after_effect.the_sprite = entity.get_node("Sprite2D")
#
#	if (entity is RespawnLamp):
#		respawn_point = entity
#		save_at_light(entity)
#	else:
#		#update the collision layer and mask of the entity
#		entity.collision_layer = ColMath.strip_bits(entity.collision_layer,ColMath.Layer.NON_PLAYER_ENTITY)
#		entity.collision_layer |= ColMath.Layer.PLAYER
#	
#		#update the collision mask of the entity
#		entity.collision_mask = ColMath.strip_bits(entity.collision_mask,ColMath.Layer.PLAYER)
#		entity.collision_mask |= ColMath.Layer.NON_PLAYER_ENTITY
	
	#save a reference to the possesed entity
#	possesed_entity = entity
#	possesed_entity.connect("die",Callable(self,"on_possesed_die"))
#	process_mode = Node.PROCESS_MODE_DISABLED

func compute_velocity(vel : Vector2)->Vector2:	
	if not possesed:
		return Vector2(0,0)
	match state:
		EntityState.DEFAULT:
			return super.compute_velocity(vel)
		LeniState.POSSESING:
			return posses_velocity
	
	#just in case
	return super.compute_velocity(vel)

func compute_action(event : InputEvent)->void:
	match state:
		LeniState.POSSESING:
			#while we are possesing we do NOT
			#update player input
			pass
		_:
			super.compute_action(event)

func main_process(delta):
	#Leni does NOTHING if he is not possesed
	if possesed:
		super.main_process(delta)
	#if possesed_entity:
	#	$mainCam.global_position = possesed_entity.global_position

#overload the usual input
#because Leni ALWAYS listens to input
func main_input(event)->void:
	compute_action(event)

func on_col(col)->void:
	match state:
		LeniState.POSSESING:
			if (col.get_collider() is Entity) and (abs(col.get_normal().x) > abs(col.get_normal().y)):
				state = EntityState.BRICK
				possesed_entity = col.get_collider()
				$Sprite2D.custom_play("posses_col")
	super.on_col(col)

func _on_posses_timer_timeout():
	posses_velocity = Vector2(0,0)
	if state != EntityState.BRICK:
		$Sprite2D.custom_play("posses_end")

func _on_sprite_2d_animation_finished():
	match $Sprite2D.animation:
		"posses_col":
			possesed_entity.posses_by(self)
		"posses":
			pass #this is handled in the sprite2d
		"posses_launch":
			pass #handled in sprite2d
		"die":
			ghost_after_effect.queue_free()
			super.die()
		_:
			self.state = EntityState.DEFAULT
