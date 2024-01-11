extends Entity

#this class represents the rotating pumkin enemy

class_name RotatingPumpkin 

@export var gravity : Vector2 #gravity pulling the physics possesion
@export var net_force : Vector2 #net force set by the player
@export var player_control : Vector2

@export var terminal_velocity : Vector2 
@export var friction : Vector2 #friction proportionality constant 0 is no friction 1 is infinit friction

@export var jump_speed : float #ratio of x speed to jump
@export var jump_max : float  
@export var jump_min : float 

#when we detect something we should damage
#how much does it need to be in phase with the velocity
#to take a hit?
#ranges from 0, directly in phase, to 4, completely out of phase
#so with a direction threshold of 4, WE ARE LAVA and all will take damage
@export var damage_direction_threshold : float = 1.5
#how fast do we have to be going to deal damage?
@export var damage_speed_threshold : float = 2


@export var size : Size = Size.MEDIUM :
	set (val):
		size = val 
		self.scale = get_size_scale(size)
	get:
		return size

@export var size_scales : Array[Vector2]


#rotation radius used to indicate our approximate radius when computing rotation speed
var rotation_radius : float = 1


#this is a reference to the glow effect that covers us when we are possesed
#it is set on possesion and recorded for our use
var ghost_after_effect : GhostAfterEffectNode = null

enum Size {
	SMALL,
	MEDIUM,
	BIG
}

enum RotatingPumkinState {
	EXPLOADING = Entity.ENTITY_STATE_COUNT,
	LAUNCHING
}


func get_entity_type()->String:
	return "RotatingPumpkin"  

func get_size_scale(size : Size)->Vector2:
	return self.size_scales[size]

func posses_by(entity)->void:
	super.posses_by(entity)
	if entity.ghost_after_effect:
		self.ghost_after_effect = entity.ghost_after_effect 
	$damage_zone.collision_mask = ColMath.strip_stationary_bits(entity.gen_col_mask())
func exorcize(offset : Vector2 = Vector2(0,0)):
	super.exorcize(offset)
	self.ghost_after_effect = null #clear out the reference to the after effect
	$damage_zone.collision_mask = ColMath.strip_stationary_bits(self.gen_col_mask())

#adds a force to the object
func add_impulse(force : Vector2)->void:
	net_force += force 

#returns true if we are supposed to be blocking input
func shouldBlockInput()->bool:
	return self.state == RotatingPumkinState.EXPLOADING or self.state == RotatingPumkinState.LAUNCHING

func on_action_press(action : String)->void:
	if (self.shouldBlockInput()): return #we are a brick in the exploading state
	if action == "JUMP" and self.onground:
		#we jump higher if we move FASTER
		#give up control for height
		self.velocity.y = -clamp(self.jump_speed*abs(self.velocity.x),jump_min,jump_max) 
	elif action == "ATTACK":
		self.get_sprite2D().custom_play("expload")
		self.state = RotatingPumkinState.EXPLOADING
		self.velocity *= 0
	super.on_action_press(action)
#uses player input to compute net force on the body
func compute_force()->Vector2:
	var ret_val : Vector2 = Vector2(0,0)
	
	if not self.shouldBlockInput(): #if we are exploading do nothing :)
		for act in self.pressed_inputs:
			if self.pressed_inputs[act]: ret_val += action2velocity(act)

	return ret_val*player_control
		

func _physics_process(delta)->void:
	if self.state == RotatingPumkinState.EXPLOADING: return
	self.velocity += (compute_force() + gravity-self.velocity*friction)*delta 

	#have x and y terminal velocity seperate to avoid oddities on jump
	if abs(velocity.x) > self.terminal_velocity.x:
		self.velocity.x = self.terminal_velocity.x * (-1 if self.velocity.x < 0 else 1)
	if abs(self.velocity.y) > self.terminal_velocity.y:
		self.velocity.y = self.terminal_velocity.y * (-1 if self.velocity.y < 0 else 1)
	
	#since we need the delta on the collision, were a bit hard pressed to use the on_col funciton here
	var col = self.singal_move_and_collide(self.velocity*delta)
	
	if not col:	 return

	var normal : Vector2 = col.get_normal()
	var projection : Vector2 = self.velocity.project(normal)
	self.velocity -= projection
	self.singal_move_and_collide(self.velocity*delta) #slide after colliding
	
	#updtae the rotation speed and send normal information to the animation system
	self.get_sprite2D().rotation_speed = self.velocity.length()*(-1 if self.velocity.x < 0 else 1)/self.rotation_radius
	if self.get_sprite2D().ouch_threshold < projection.length():
		self.get_sprite2D().custom_play("ouch")

	if self.state == RotatingPumkinState.LAUNCHING:
		self.plant_tree(normal)

#goes from one size to the next size
func cycle_size()->void:
	size = ((size + 1) % len(Size.values()))
	self.rotation_radius = sqrt(self.scale.x*self.scale.y)*2

func plant_tree(normal)->void:
#var tree_spawner_packed_scene  : PackedScene = 
	var inst = load("res://scenes/entities/halloween/rollingPumpkin/pumpkin_tree_spawner.tscn").instantiate()

	cycle_size()
	
	inst.scale = self.scale

	if self.possesed:
		print_debug("adding focus point")
		get_parent().get_cam_ref().add_node_target(inst,20)
		if self.ghost_after_effect:
			self.ghost_after_effect.visible = false

	#just to be safe clear the currently stored inputs
	#self.clear_stored_inputs()

	get_parent().add_child(inst)
	inst.global_position = self.global_position
	inst.pumpkin_reference = self 


	#reset our velocity and animations
	self.state = EntityState.DEFAULT 
	self.velocity*=0

	get_parent().remove_child(self)
	inst.rotation = normal.angle()+PI/2


	self.get_sprite2D().reset_animation()


func main_ready()->void:
	self.get_sprite2D().animation_finished.connect(self.anim_finished)
	super.main_ready()

	#make sure the size of the pumpkin is synced
	self.size = size
	self.tree_entered.connect(on_tree_entered)
	$damage_zone.collision_mask = ColMath.strip_stationary_bits(self.gen_col_mask())
	$damage_zone.body_entered.connect(self.on_damage_zone_entered)
func on_damage_zone_entered(body)->void:
	if self.velocity.length_squared() < self.damage_speed_threshold * self.damage_speed_threshold: return
	if not body.has_method("take_damage"): return

	#ensure that we are moving TWARDS the body
	#we do not deal damage if the body sneaks up on us
	var body_delta = (body.global_position - self.global_position).normalized()
	print_debug((body_delta - self.velocity.normalized()).length_squared())
	
	if (body_delta - self.velocity.normalized()).length_squared() > self.damage_direction_threshold: return


	body.take_damage(self.size,self)
func on_tree_entered()->void:
	self.get_sprite2D().reset_animation()
	self.get_sprite2D().play("RESET")
	self.get_sprite2D().reset_scale()
	self.sync_stored_inputs()
	if self.possesed and self.ghost_after_effect:
		self.ghost_after_effect.visible = true


#enter the launch mode where we go flying!
func launch()->void:
	self.state = RotatingPumkinState.LAUNCHING

	get_sprite2D().rolling = false #disable the rolling flag in the animation system so our animation plays
	get_sprite2D().custom_play("seed")
	
	self.velocity.y = -10
	self.velocity.x = 0

	if self.pressed_inputs["LEFT"]:
		self.velocity.x -= 50
	if self.pressed_inputs["RIGHT"]:
		self.velocity.x += 50

	#we can go UP if we have to
	if self.velocity.x == 0: self.velocity.y *= 4

func anim_finished(anim : StringName)->void:
	match anim:
		"roll_prep":
			self.velocity += Vector2(10 * (-1 if self.velocity.x < 0 else 1),-20) #quick boost to velocity after the pumpkin "thrusts"
		"expload":
			launch() #shoot ourselfs up into the air
	
func main_process(delta)->void:
	super.main_process(delta)
