extends KinColObject

class_name Entity

#TODO: the health code should probably be moved to another set of entites, 
#just because the NPC's don't deal with health or AI

#this is the generic entity script that all
#collision game objects are inteanded to draw from

@export var sprite : AnimatedSprite2D  = null 

#how far away from the unpos spot can we move up down left or right
@export var unposses_radius : float  = 100

#this is a variable to an AI resource
#that tells us how to run when not possesed
#null indicates no action
@export var entity_ai : EntityAI

func get_entity_type()->String:
	return "Entity"

#we can store values in this array to indicate what images the game
#should use for hearts of this entity when loading hp from an entity,
#empty array means no objects
@export var heart_text : Array[Texture2D] = []

#this is a string representing the level that we originaly came from
var home_level : String 
var home_name : String

signal sig_died
signal sig_possesed_by
signal sig_unpossesed_by
signal sig_after_load
signal sig_before_load

func get_sprite2D()->AnimatedSprite2D:
	if sprite != null: return sprite 
	return $Sprite2D

#traverse the tree to get to the main scene of the entire game
func get_main()->MainScene:
	var main = get_parent()
	while not main is MainScene:
		main = main.get_parent()
	return main


#returns a measure of how dangerous this entity is,
#used for dynamic music and threat detection
func get_danger_level()->int:
	if not self.possesed and self.entity_ai != null:
		return self.entity_ai.danger_level
	return 0
				
#this function is called after we have entered the scene as the player
#possesed entity
func after_load(level)->void:
	grab_camera()
	if entity_ai:
		entity_ai.caller = self
	
	#let anyone else who is interested in level loading know
	sig_after_load.emit(level)

#called before we are removed from the tree for loading
func before_load()->void:
	#this signal is grabed by the llp.gd node
	#to mark us as bieng absent
	sig_before_load.emit()


#this function is inteanded to be overloaded
#and is called any time that an entity is moved into a loaded level
#via door code from the GameLoader singleton
#note that it is called BEFORE the entity is added to the tree
#so you can think about it as a place to put extra hooks that any given entity
#needs to run before loading
func on_level_load(_lvl)->void:
	pass


#reference to the entity we are currently possesing
var possesed_entity : Entity = null :
	set(val):
		possesed_entity = val
		clear_stored_inputs()
	get:
		return possesed_entity

#collsiion layer and mask to return to after taking damage
var saved_col_layer : int
var saved_col_mask : int

#grabs the camera to follow this entity
func grab_camera()->void:
	var lvlParent = get_parent() as Level
	lvlParent.cam_ref.target = self

#wether or not the entity can be possesed by the player
var can_posses : bool = true

#are we possesed by the ghost?
#flag that overrules the test possesion
var possesed : bool = false : set = set_possesed,get = get_possesed
func set_possesed(val : bool)->void:
	possesed = val
func get_possesed()->bool:
	return (self.possesed_entity != null) || possesed


func on_ground_changed(val : int)->void:
	pass


#indicates if we are checked the ground
var onground : bool = false : set = set_onground,get = get_onground
func set_onground(val : bool)->void:
	onground = val
	update_animation()
func get_onground()->bool:
	return $GroundTester.has_overlapping_bodies()#ground_counter > 0

#health of the entity, if this hits zero we die

@export 
var max_health : int = 7

@export
var health : int = 7 : set = set_health, get = get_health
func set_health(val : int)->void:
	if state != EntityState.DAMAGED:
		if val <= 0:
			die()
		else:
			if val < health:
				self.state = EntityState.DAMAGED
			elif val > max_health:
				val = max_health
			health = val 
	if self.possesed:
		get_parent().display_hp(self.health,self.max_health,self.heart_text)
func get_health()->int:
	return health

#used when we want do more than just remove_at ourselfs from the scene
func die():
	self.sig_died.emit(self)
	var damage_entity = null
	
	if self.possesed:
		damage_entity = self.possesed_entity
	
	exorcize()

	#we need to do this after exorcize in order for the health to
	#update and display properly
	#as such we need to cache a few variables that will be unset when exorcizing
	if damage_entity != null:
		damage_entity.take_damage(1,"exorcize")

	queue_free()

#gets the entity to request battle music be played

#called when we take damage, inteanded to be overloaded
func take_damage(dmg : int = 1, dmg_src = null)->void:
	self.health -= dmg
	if self.possesed:
		self.get_parent().get_main().music_system.set_flag("hit")
	#if we were hit, enable the battle music
#stores inputs that are pressed and will remain true
#for as long as the input is not released
var pressed_inputs : Dictionary = {
	"RIGHT":false, #the first value indicates if we are pressed
	"LEFT":false, #the second value indicates if we have been double pressed
	"UP":false,
	"DOWN":false,
	"ATTACK":false,
	"JUMP":false,
	"UNPOSSES":false
}

#used for making new enumerators in child classes
const ENTITY_STATE_COUNT = 4
#an enumerator of entity state
enum EntityState {
	DEFAULT = 0,
	BRICK,
	DAMAGED,
	DAZED
}

#gets the load path from the parent of the respawn lamp
func get_level_path()->String:
	return self.get_parent().load_path

#state variable used in all entities
var state : int = EntityState.DEFAULT : set = set_state, get = get_state
func set_state(val : int)->void:
	match val:
		EntityState.DAZED:
			if $dazed_timer:
				$dazed_timer.start()
			else:
				state = EntityState.DEFAULT
		EntityState.DAMAGED:
			saved_col_layer = collision_layer
			saved_col_mask = collision_mask
			collision_layer = 0
			collision_mask = ColMath.ConstLayer.TILE_BORDER | ColMath.Layer.TERRAIN
			if get_sprite2D():
				get_sprite2D().custom_play("damage")
			if $modulate_timer:
				$modulate_timer.start()
	state = val
func get_state()->int:
	return state

#used for computing double presses
var last_pressed_action : String = ""
var last_pressed_action_time : int = 0

#clears out the input store array
#useful for resetting input
func clear_stored_inputs():
	for key in pressed_inputs:
		pressed_inputs[key] = false
	update_animation()

func main_ready():
	self.add_to_group("Npc")

	self.onground = false
	if $GroundTester:
		$GroundTester.connect("body_entered",Callable(self,"_on_GroundTester_body_entered"))
		$GroundTester.connect("body_exited",Callable(self,"_on_GroundTester_body_exited"))
		$GroundTester.collision_layer = 0
		$GroundTester.collision_mask = ColMath.ConstLayer.TILE_BORDER | ColMath.Layer.TERRAIN
	if $modulate_timer:	
		$modulate_timer.connect("timeout",Callable(self,"on_modulate_timer_out"))
		$modulate_timer.wait_time = 0.3
		$modulate_timer.one_shot = true
		
	if $dazed_timer:	
		$dazed_timer.connect("timeout",Callable(self,"on_dazed_timer_out"))
		$dazed_timer.wait_time = 0.5
		$dazed_timer.one_shot = true 
	
	if entity_ai:
		var persistence = get_node("LiveLevalPersistanceNode")
		if not (persistence and persistence.is_marked_for_removal()):
			entity_ai.setup(self)
	
	self.home_level = get_parent().load_path 
	#name can get changed between loading, so we need
	#to store it so that it remains constant
	self.home_name = self.name

	#update the hp display
	self.health = self.health

func on_dazed_timer_out():
	self.state = EntityState.DEFAULT
#called when an action is double pressed
func on_action_double_press(action : String)->void:
	if self.possesed and action == "UP":
		exorcize()

#runs only when the action is just pressed
func on_action_press(action : String)->void:
	if self.possesed and action == "UNPOSSES":
		exorcize(get_stored_action_velocity())

#runs only when the action is released
func on_action_released(action : String)->void:
	pass

#takes as input an action and wether or not it is double pressed,
#then performs the given action
func perform_action(act : String,
pressed : bool,
double_press : bool = false,
echo : bool = false)->void:
	if state == EntityState.DAZED: return
	if pressed:
		on_action_press(act)
		pressed_inputs[act] = true
		if double_press:
			on_action_double_press(act)
	else:
		pressed_inputs[act] = false
		on_action_released(act)
	if not echo:
		update_animation()
			
#performs the given action checked the entity
#inteanded to be overloaded by the individual class
func compute_action(event : InputEvent)->void:
	for key in pressed_inputs:
		#yes this if statement is hideous, but it gaurds against
		#echo events where event.is_aciton_pressed is false
		#but we want move_right to be true
		if event.is_action_pressed(key):
			
			perform_action(key,true,false,event.is_echo())
			
			var current_input_time = Time.get_ticks_msec()


			if last_pressed_action == key and (current_input_time - last_pressed_action_time) < 300:
				perform_action(key,true,true,event.is_echo())

			#update the last pressed values
			last_pressed_action = key
			last_pressed_action_time = current_input_time
				
		elif event.is_action_released(key):
			pressed_inputs[key] = false
			perform_action(key,false,false,event.is_echo())

#called when we posses another entity
func on_posses(posesee):
	pass

#something wants to posses us
func posses_by(entity)->void:
	#clear out the existing possesed entity
	if self.possesed:
		exorcize()

	#if the entity has an after effect, apply it to ourselfs
	if entity.ghost_after_effect:
		entity.ghost_after_effect.the_sprite = get_sprite2D()
	if entity.has_method("on_posses"):
		entity.on_posses(self)
	#update the collision layer and mask of the self
	self.collision_layer = ColMath.strip_bits(self.collision_layer,ColMath.Layer.NON_PLAYER_ENTITY)
	self.collision_layer |= ColMath.Layer.PLAYER | ColMath.ConstLayer.PLAYER

	#update the collision mask of the self
	self.collision_mask = ColMath.strip_bits(self.collision_mask,ColMath.Layer.PLAYER)
	self.collision_mask |= ColMath.Layer.NON_PLAYER_ENTITY
	
	#save a reference to the possesed entity
	self.possesed_entity = entity
	
	get_parent().remove_child(entity)
	#prevent the entity from processing anything
	entity.process_mode = Node.PROCESS_MODE_DISABLED
	clear_stored_inputs() #clear up the stored inputs

	#update the health dispaly
	self.health = self.health

	#alert others that we have been possesed
	sig_possesed_by.emit(self,entity)
	grab_camera()

#called on the entity we exorcize when removing it
func on_unposses(_host)->void:
	#update the health display
	self.health = self.health
	update_animation()


#returns true if unpossessing this entity will NOT
#send Leni into some terrain
func is_clear_to_unposses(offset : Vector2)->bool:
	var target_position : Vector2 = unposses_position(offset)
	var space_state =  get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position,target_position,ColMath.ConstLayer.TILE_BORDER)
	query.exclude = [self]
	return not space_state.intersect_ray(query)

#clears our possesion	
func exorcize(offset : Vector2 = Vector2(0,0))->void:
	if not self.possesed: return
	if not self.is_clear_to_unposses(offset): return

	if self.possesed_entity != null:
		if self.possesed_entity.ghost_after_effect:
			self.possesed_entity.ghost_after_effect.the_sprite = self.possesed_entity.get_sprite2D()

		get_parent().add_child(self.possesed_entity)	

		possesed_entity.global_position  = unposses_position(offset)
		self.possesed_entity.process_mode = Node.PROCESS_MODE_INHERIT
		self.possesed_entity.on_unposses(self)
		sig_unpossesed_by.emit(self,self.possesed_entity)
		self.possesed_entity = null

	self.collision_layer = gen_col_layer()
	self.collision_mask = gen_col_mask()

	if $dazed_timer:
		self.state = EntityState.DAZED
	self.possesed = false

#runs the AI if acceptable
func run_AI(player_enemy)->void:
	if not self.possesed and entity_ai:
		entity_ai.tick(player_enemy)


#this function is called at the end of perform_action
#and updates the animation to match the action performed
func update_animation()->void:
	pass


#process function that we can overload	
func main_process(delta):
	if state != EntityState.BRICK:
		singal_move_and_collide(speed*delta*compute_velocity(velocity))


#returns the velocity represented by currently pressed inputs
func get_stored_action_velocity()->Vector2:
	var ret_val : Vector2 = Vector2(0,0)
	for act in self.pressed_inputs:
		if self.pressed_inputs[act]:
			ret_val += self.action2velocity(act)
	return ret_val

#this is a utility function that converts an event into a direction
#in the game
func action2velocity(action : String)->Vector2:
	match action:
		"RIGHT":
			return Vector2(1,0)
		"LEFT":
			return Vector2(-1,0)
		"UP":
			return Vector2(0,-1)
		"DOWN":
			return Vector2(0,1)
	return Vector2(0,0)

#gets the direction currently bieng pressed by the entity/ player
func get_pressed_direction()->Vector2:
	var ret_val = Vector2(0,0)
	for act in self.pressed_inputs:
		if self.pressed_inputs[act]:
			ret_val += self.action2velocity(act)
	return ret_val

#default collision generators
func gen_col_layer()->int:
	return ColMath.Layer.NON_PLAYER_ENTITY
func gen_col_mask()->int:
	return ColMath.Layer.TERRAIN | ColMath.ConstLayer.TILE_BORDER | ColMath.Layer.PLAYER

#calls for syncing the pressed actions to the players current controls
#syncs the pressed actions to the players current controls
func sync_stored_inputs()->void:
	#there is NO need to run this function
	#if we are not possesed, as the stored inputs 
	#are entirely generated from the AI
	if not self.possesed: return

	for act in self.pressed_inputs:
		self.pressed_inputs[act] = Input.is_action_pressed(act)



func main_input(event)->void:
	#we only care about inputs if we are possesed, otherwise we
	#let the AI run
	if possesed and event.is_action_type():
		compute_action(event)

#gets the position that Leni needs to go to when he
#unposseses the entity
#defaults to the entities position if no position
#is given
func unposses_position(offset : Vector2 = Vector2(0,0))->Vector2:
	if $unposSpot is Node2D:
		return $unposSpot.global_position + offset * self.unposses_radius
	return position

func _input(event):
	main_input(event)

func _on_GroundTester_body_entered(body):
	if body != self:
		self.on_ground_changed(1)

func _on_GroundTester_body_exited(body):
	if body != self:
		self.on_ground_changed(0)

#convinence function to spawn an instance
func spawn_instance(inst, global_pos : Vector2):
	if inst is Node2D:
		get_parent().add_child(inst)
		inst.global_position = global_pos
		return inst
#convinence function to spawn an object at a given position
func spawn_object(pc : PackedScene,global_pos : Vector2):
	var inst = pc.instantiate()
	return spawn_instance(inst,global_pos)
#convinecne function that adds a given object as a child parent
#at our global position
func add_to_parent_at(obj,global_pos : Vector2):
	if obj is Node2D:
		obj.global_position = global_pos
		get_parent().add_child(obj)
		return obj
#convinence function for shooting projectiles
func shoot(proj : PackedScene,global_pos : Vector2,velocity : Vector2):
	var obj = proj.instantiate()
	
	obj.velocity = velocity
	
	var ret_val =  spawn_instance(obj,global_pos)
	
	ret_val.collision_mask = collision_mask 
	
	return ret_val

func on_modulate_timer_out():
	state = EntityState.DEFAULT
	collision_layer = saved_col_layer
	collision_mask = saved_col_mask
	update_animation()


#called when we detect a collision
func on_col(col):
	pass
	if col.get_collider() is Entity and col.get_normal().y < col.get_normal().x*2:

		var offset = self.global_position.x - col.get_collider().global_position.x
		
		if offset >= 0:
			offset = 1
		else:
			offset = -1
		
		#move us off of the top based collision
		move_and_collide(Vector2.RIGHT * offset * 10)

