extends KinColObject

class_name Entity

#this is the generic entity script that all
#collision game objects are inteanded to draw from

signal died

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
var possesed : bool = true : set = set_possesed,get = get_possesed
func set_possesed(val : bool)->void:
	possesed = val
func get_possesed()->bool:
	return (self.possesed_entity != null) || possesed


var ground_counter : int = 0 : set = set_ground_counter,get = get_ground_counter
func set_ground_counter(val : int)->void:
	ground_counter = val
func get_ground_counter()->int:
	return ground_counter

func incriment_ground_counter():
	self.ground_counter += 1
	update_animation()
func decriment_ground_counter():
	if self.ground_counter > 0:
		self.ground_counter -= 1
	update_animation()

#indicates if we are checked the ground
var onground : bool = false : set = set_onground,get = get_onground
func set_onground(val : bool)->void:
	onground = val
	update_animation()
func get_onground()->bool:
	return ground_counter > 0

#health of the entity, if this hits zero we die
var health : int = 7 : set = set_health, get = get_health
func set_health(val : int)->void:
	if state != EntityState.DAMAGED:
		if val <= 0:
			die()
		else:
			if val < health:
				self.state = EntityState.DAMAGED

			health = val
func get_health()->int:
	return health

#used when we want do more than just remove_at ourselfs from the scene
func die():
	emit_signal("die")
	queue_free()
#called when we take damage, inteanded to be overloaded
func take_damage(dmg : int = 1, dmg_src = null)->void:
	self.health -= dmg

#stores inputs that are pressed and will remain true
#for as long as the input is not released
var pressed_inputs : Dictionary = {
	"RIGHT":false, #the first value indicates if we are pressed
	"LEFT":false, #the second value indicates if we have been double pressed
	"UP":false,
	"DOWN":false,
	"ATTACK":false,
	"JUMP":false
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

#state variable used in all entities
var state : int = EntityState.DEFAULT : set = set_state, get = get_state
func set_state(val : int)->void:
	match val:
		EntityState.DAZED:
			$dazed_timer.start()
		EntityState.DAMAGED:
			saved_col_layer = collision_layer
			saved_col_mask = collision_mask
			collision_layer = 0
			collision_mask = ColMath.ConstLayer.TILE_BORDER | ColMath.Layer.TERRAIN
			$Sprite2D.custom_play("damage")
			modulate = Color.LIGHT_GRAY
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
	self.onground = false
	$GroundTester.connect("body_entered",Callable(self,"_on_GroundTester_body_entered"))
	$GroundTester.connect("body_exited",Callable(self,"_on_GroundTester_body_exited"))
	$GroundTester.collision_layer = 0
	$GroundTester.collision_mask = ColMath.ConstLayer.TILE_BORDER | ColMath.Layer.TERRAIN
	
	$modulate_timer.connect("timeout",Callable(self,"on_modulate_timer_out"))
	$modulate_timer.wait_time = 0.3
	$modulate_timer.one_shot = true
	
	
	$dazed_timer.connect("timeout",Callable(self,"on_dazed_timer_out"))
	$dazed_timer.wait_time = 0.5
	$dazed_timer.one_shot = true

func on_dazed_timer_out():
	self.state = EntityState.DEFAULT
#called when an action is double pressed
func on_action_double_press(action : String)->void:
	if self.possesed and action == "UP":
		exorcize()

#runs only when the action is just pressed
func on_action_press(action : String)->void:
	pass
#runs only when the action is released
func on_action_released(action : String)->void:
	pass

#takes as input an action and wether or not it is double pressed,
#then performs the given action
func perform_action(act : String,pressed : bool,double_press : bool = false,echo : bool = false)->void:
	if state != EntityState.DAZED:
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


#this function is called when we are NOT possesed
#and is inteanded to feed inputs into the perform_action function
#it takes as its inputs the player position 
func AI(player_enemy)->void:
	pass

#something wants to posses us
func posses_by(entity)->void:

	#clear out the existing possesed entity
	if self.possesed:
		exorcize()

	#if the entity has an after effect, apply it to ourselfs
	if entity.ghost_after_effect:
		entity.ghost_after_effect.the_sprite = get_node("Sprite2D")

	#update the collision layer and mask of the self
	self.collision_layer = ColMath.strip_bits(self.collision_layer,ColMath.Layer.NON_PLAYER_ENTITY)
	self.collision_layer |= ColMath.Layer.PLAYER

	#update the collision mask of the self
	self.collision_mask = ColMath.strip_bits(self.collision_mask,ColMath.Layer.PLAYER)
	self.collision_mask |= ColMath.Layer.NON_PLAYER_ENTITY
	
	#save a reference to the possesed entity
	self.possesed_entity = entity
	
	get_parent().remove_child(entity)
	#prevent the entity from processing anything
	entity.process_mode = Node.PROCESS_MODE_DISABLED

	grab_camera()

#called on the entity we exorcize when removing it
func on_unposses(host)->void:
	update_animation()

#clears our possesion	
func exorcize()->void:
	if self.possesed:
		if self.possesed_entity != null:
			if self.possesed_entity.ghost_after_effect:
				self.possesed_entity.ghost_after_effect.the_sprite = self.possesed_entity.get_node("Sprite2D")

			get_parent().add_child(self.possesed_entity)	

			possesed_entity.global_position  = unposses_position()
			self.possesed_entity.process_mode = Node.PROCESS_MODE_INHERIT
			self.possesed_entity.on_unposses(self)
			self.possesed_entity = null

		self.collision_layer = gen_col_layer()
		self.collision_mask = gen_col_mask()

		self.state = EntityState.DAZED
		self.possesed = false

#runs the AI if acceptable
func run_AI(player_enemy)->void:
	if not self.possesed:
		AI(player_enemy)


#this function is called at the end of perform_action
#and updates the animation to match the action performed
func update_animation()->void:
	pass


#process function that we can overload	
func main_process(delta):
	if state != EntityState.BRICK:
		singal_move_and_collide(speed*delta*compute_velocity(velocity))


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
	
#default collision generators
func gen_col_layer()->int:
	return ColMath.Layer.NON_PLAYER_ENTITY
func gen_col_mask()->int:
	return ColMath.Layer.TERRAIN | ColMath.ConstLayer.TILE_BORDER | ColMath.Layer.PLAYER

func main_input(event)->void:
	#we only care about inputs if we are possesed, otherwise we
	#let the AI run
	if possesed and event.is_action_type():
		compute_action(event)

#gets the position that Leni needs to go to when he
#unposseses the entity
#defaults to the entities position if no position
#is given
func unposses_position()->Vector2:
	if $unposSpot is Node2D:
		return $unposSpot.global_position
	return position

func _input(event):
	main_input(event)

func _on_GroundTester_body_entered(body):
	if body != self:
		incriment_ground_counter()
func _on_GroundTester_body_exited(body):
	if body != self:
		decriment_ground_counter()

#convinence function to spawn an object at a given position
func spawn_object(pc : PackedScene,global_pos : Vector2):
	var inst = pc.instantiate()
	if inst is Node2D:
		get_parent().add_child(inst)
		inst.global_position = global_pos
		return inst
#convinecne function that adds a given object as a child parent
#at our global position
func add_to_parent_at(obj,global_pos : Vector2):
	if obj is Node2D:
		obj.global_position = global_pos
		get_parent().add_child(obj)
		return obj
#convinence function for shooting projectiles
func shoot(proj : PackedScene,global_pos : Vector2,velocity : Vector2):
	var obj = spawn_object(proj,global_pos)
	obj.velocity = velocity
	obj.collision_mask = collision_mask
	return obj
func on_modulate_timer_out():
	modulate = Color.WHITE
	state = EntityState.DEFAULT
	collision_layer = saved_col_layer
	collision_mask = saved_col_mask
	update_animation()


#called when we detect a collision
func on_col(col):
	pass
