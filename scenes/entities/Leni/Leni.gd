extends TiredFlightEntity

#this class represents the player ghost
#that posseses stuff

class_name Leni

func get_entity_type()->String:
	return "Leni"

#the hp that the player starts with, saved for when we die
#hp we spawn with
@export var start_hp : int = 5

@export var invensible_timer : Timer

@export var teleport_speed_ratio : float = 100
@export var teleport_direction_speed : Vector2 = Vector2(100,40)
@export var teleport_direction_speed_buffed : Vector2 = Vector2(200,80)

@export var posses_speed : float = 5

@export var after_effect_color_a : Color
@export var after_effect_color_b : Color

@export var boosted_after_effect_color_a : Color
@export var boosted_after_effect_color_b : Color

#the number of jumps we can make while tired
@export var tired_jumps = 2 : 
	get:
		return tired_jumps
	set(val):
		#make sure to cap the saved_jumps
		if saved_jump > val:
			saved_jump = val
		
		self.update_follow_color(val > 2)

		tired_jumps = val

#the squred theshold that indicates if our previous posses_dir is too close to our current posses
#dir
@export var posses_threshold : float = 1

#the last direction that we possesed in, 0 bieng no tp
var last_posses_dir : Vector2 = Vector2(0,0)

#the current number of jumps we have left while tired
var saved_jump : int = 1 :
	get:
		return saved_jump
	set(val):
		saved_jump = val
		if saved_jump <= 0:
			$posess_cooldown.start()
			saved_jump = 0

func set_tired(val)->void:
	super.set_tired(val)
	if self.reset_on_tired:
		self.reset_on_tired = false
		self.saved_jump = self.tired_jumps
		self.last_posses_dir = Vector2(0,0)



#resets the player health for the level
#as well as doing any other action that needs to be done
#checked health reset
func reset_health()->void:
	health = start_hp

#a reference to the lamp that we respawn at
var respawn_point : RespawnLamp
@export var ghost_after_effect : GhostAfterEffectNode


func update_follow_color(boosted : bool)->void:
	if not boosted:
		self.ghost_after_effect.color_a = self.after_effect_color_a
		self.ghost_after_effect.color_b = self.after_effect_color_b
	else:
		self.ghost_after_effect.color_a = self.boosted_after_effect_color_a
		self.ghost_after_effect.color_b = self.boosted_after_effect_color_b

#simple conviennce function to store the current
#entity as one the game should target
func store_aggro(host):
	get_parent().player_entity = host 

#leni dies AFTER we finish the die animation
#so hijak die and call super.die when the anim finishes
func die():
	self.state = EntityState.BRICK
	get_sprite2D().custom_play("die")

#convinence function to ensure that we are the object
#that the game targets
func grab_aggro():
	store_aggro(self)
func take_damage(dmg : int = 1, src = null)->void:
	if (invensible_timer.time_left <= 0 and self.get_sprite2D().animation != "posses") or str(src) == "exorcize": #we take no damage while possesing
		super.take_damage(dmg,src)

func on_unpos_buff_timer_stop():
	#reset the tired_jumps to the start
	self.tired_jumps = 2
	super.on_ground_changed(0) #indicate that we need to check if we are flying

#called on the entity we exorcize when removing it
func on_unposses(host)->void:
	self.state = EntityState.DEFAULT
	
	#ensure we have no lingering rotation
	get_sprite2D().rotation = 0
	
	grab_camera()
	grab_aggro() #ensure that leni is targeted
	self.sync_stored_inputs()

	invensible_timer.start()

	self.tired = false #we get fly even higher after coming out of possesion
	self.tired_jumps = 3

	#var temp_time = $posess_cooldown.wait_time
	#$posess_cooldown.wait_time = 0
	#$posess_cooldown.start() #we can now teleport again
	#$posess_cooldown.wait_time = temp_time

	$posess_cooldown.stop()
	$posess_cooldown.timeout.emit()
	$unpos_buff_timer.start() #we get buffed for a time after we posses something
	$flight_timer.stop() #no need to worry about flight for the time bieng
	
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


	#Leni is not an npc
	remove_from_group("Npc")
	possesed = true #make sure we start as possesed
	$unpos_buff_timer.timeout.connect(self.on_unpos_buff_timer_stop)
	$posess_cooldown.timeout.connect(self.on_posses_cooldown_stop)

#indicates if we are ready to reset the jump count
var reset_on_tired : bool = false
func on_posses_cooldown_stop()->void:
	if not self.tired:
		self.saved_jump = self.tired_jumps
		self.last_posses_dir = Vector2(0,0)
	else:
		reset_on_tired = true

func can_jump()->bool:
	return $jump_timer.is_stopped() #we can jump if the timer is NOT running

#performs the jump gaurenteed
#no questions ask, teleport go brrrr
#teleports leni if it is acceptable
func jump()->void:
	#we teleport VERY far after unpossesing
	var computed_vel = (self.compute_velocity(self.velocity)).normalized()*self.teleport_speed_ratio
	
	computed_vel *= (self.teleport_direction_speed if $unpos_buff_timer.time_left == 0 \
								else self.teleport_direction_speed_buffed)

	
	#breifly change our collision mask for the teleport
	self.collision_mask = ColMath.ConstLayer.TILE_BORDER | ColMath.Layer.TERRAIN
	self.singal_move_and_collide(computed_vel)
	self.collision_mask = self.gen_col_mask()
	$TeleportSound.play()
	
	#self.global_position = result.



#jumps if it is possible to jump
func safe_jump()->void:
	if self.can_jump():
		self.jump()
		$jump_timer.start()

func on_action_press(act : String)->void:
	if act == "ATTACK":
		posses_attack(compute_velocity(velocity).normalized()*self.posses_speed)
	if act == "JUMP":
		self.safe_jump()	
	super.on_action_press(act)



#runs whenever state is set and ensures the
#state machine functions properly
func set_state(val : int)->void:
	match val:
		LeniState.POSSESING:
			#you cannot posses up while tired
			if self.saved_jump <= 0: return

			if posses_velocity.length_squared() == 0:
				posses_velocity.x = self.posses_speed
				if self.get_sprite2D().flip_h:
					posses_velocity.x *= -1
			
			var normalized_dir = posses_velocity.normalized()

			if self.saved_jump != self.tired_jumps:
				#if we are in a given jump sequence we cannot go the same way twice in a row
				if normalized_dir.distance_squared_to(self.last_posses_dir) < posses_threshold*posses_threshold:
					self.last_posses_dir = normalized_dir
					self.saved_jump -= 1
					return
					#update for the next possesion time
			self.last_posses_dir = normalized_dir

			#start the timer indicating an attack started
			$posses_timer.start()

			self.collision_mask |= ColMath.Layer.SIMPLE_ENTITY
			#if they are not moving intialy, we will preload their speed for them
			#update the rotation of the sprite for the attack
			if self.get_sprite2D().flip_h:
				self.get_sprite2D().rotation = (-posses_velocity).angle()
			else:
				self.get_sprite2D().rotation = posses_velocity.angle()
			
			#decriment the number of times that we can posses without cooldown
			self.saved_jump -= 1

			#start the animation for the posses attack
			self.get_sprite2D().custom_play("posses_launch")
			$possesSound.play() #TODO: this could be moved into the animation sprite
		LeniState.POSSESING_ENTITY:
			#make us unexist
			visible = false
			collision_layer = 0
			collision_mask = 0
		EntityState.DEFAULT:
			#remove the simple entity collision when we go back to default state
			self.collision_mask = ColMath.strip_bits(self.collision_mask,ColMath.Layer.SIMPLE_ENTITY)

	super.set_state(val)

func compute_posses_velocity()->Vector2:
	var ret_val = self.get_pressed_direction()*self.posses_speed
	#if self.tired and ret_val.y < 0:
	#	ret_val.y = 0
	ret_val.y /= 2
	return ret_val 

#launch ourselfs and prepare to posses
func posses_attack(vel : Vector2)->void:
	if not $posess_cooldown.is_stopped(): return

	#store our current velocity into the posses_velocity
	posses_velocity = self.compute_posses_velocity()

	#set the state to possesing (note that this is a setter that does a ton of state stuff)
	#update our state through the setter function
	self.state = LeniState.POSSESING

#leni is a ghost, you cant posses a ghost (at least until I get around to adding it :p)
func exorcize(offset : Vector2 = Vector2(0,0)):
	pass
func posses_by(entity):
	pass


#convinence function that saves the game at the given ghost light
func save_at_light(ghostLight : RespawnLamp)->void:
	SaveUtils.save_game(Globals.game_name,
						get_parent(),
						ghostLight)


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

func main_process(delta):
	#Leni does NOTHING if he is not possesed
	if possesed:
		super.main_process(delta)

#overload the usual input
#because Leni ALWAYS listens to input
func main_input(event)->void:
	compute_action(event)

func on_col(col)->void:
	match state:
		LeniState.POSSESING:
			if (col.get_collider() is Entity):
				state = EntityState.BRICK
				possesed_entity = col.get_collider()
				get_sprite2D().custom_play("posses_col")
	super.on_col(col)

func _on_posses_timer_timeout():
	posses_velocity = Vector2(0,0)
	if state != EntityState.BRICK:
		self.state = EntityState.DEFAULT
		get_sprite2D().custom_play("posses_end")

func _on_sprite_2d_animation_finished():
	match get_sprite2D().animation:
		"posses_col":
			update_follow_color(false) #set default posses color
			possesed_entity.posses_by(self)
		"posses":
			pass
		"posses_launch":
			pass
		"posses_end":
			self.update_animation()
			self.state = EntityState.DEFAULT
		"die":
			GameLoader.load_save()
		_:
			self.state = EntityState.DEFAULT
