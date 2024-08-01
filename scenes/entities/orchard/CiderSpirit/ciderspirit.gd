extends LRJEntity

class_name CiderSpirit


@export var combination_threshold : float = 0.5
@export var hop_distance : float = 10
@export var max_jump : Vector2 = Vector2(40,30)

@export var transform_animation : AnimationPlayer
@export var parabola_position : Node2D 
@export var parabala_target_speed : float = 100


#controls how many different segments of the parabola that we draw
@export var parabala_segments : int = 4

#used when computing the time it takes us to travel a given distance via jump parabola
@export var jump_speed : float = 10

@export var follower_mug_ps : PackedScene 
var follower_mug : FollowerMug
var original_sprite_position : Vector2

func get_entity_type()->String:
	return "CiderSpirit"
func die()->void:
	follower_mug.queue_free() 
	await follower_mug.tree_exited
	super.die()

enum CiderSpiritState {
	PARABALA = Entity.ENTITY_STATE_COUNT,
	LAUNCHED,
	SPLASHED
}

var jump_time : float = 0
var jump_distance : float = 0
var jump_height : float = 0

#indicates that we are currently running animations to prep for jumping
var prepping_jump : bool = false

var do_jump_parabola : bool = false  :
	set(val):
		do_jump_parabola = val 

		if self.prepping_jump: return #we do NOT touch these if we are waiting on animations
												#to finish
		jump_time        = 0
		self.state       = CiderSpiritState.PARABALA
		self.prepping_jump = false
		queue_redraw()
	get:
		return do_jump_parabola

func on_ground_changed(val : int)->void:
	super.on_ground_changed(val) 
	if self.onground and self.state == CiderSpiritState.LAUNCHED:
		self.on_col(null)

#when we would normaly jump, we prepare to
#parabala leep
var wants_to_combine = false

func jump()->void:
	if not (self.state == CiderSpiritState.LAUNCHED or self.state == CiderSpiritState.SPLASHED):
		self.do_jump_parabola = true 
	else:
		summon_mug()

func on_level_load(lvl)->void:
	#ensure the follower mug follows us
	self.follower_mug.get_parent().remove_child(self.follower_mug)
	lvl.add_child(follower_mug)
	self.hide_follower_mug()
	super.on_level_load(lvl)

#this function launches us along the trajectory indicated by the parabala that we drew
func follow_trajectory()->void:
	if self.do_jump_parabola:

		self.do_jump_parabola = false
		var total_jump_time : float = jump_distance / jump_speed
		

		self.gravity = jump_height*4/(total_jump_time**2)/(2*speed.y)
		self.velocity.y = -4*jump_height/abs(total_jump_time)/(2*speed.y)
		self.velocity.x = jump_speed /(2*speed.x)

		if jump_distance < 0:
			self.velocity.x *= -1

		
		#indicate that we are FLYING
		self.state = CiderSpiritState.LAUNCHED
		
		$big_splash.play()

		follower_mug.global_position = global_position 
		if follower_mug:
			follower_mug.rotation = self.get_sprite2D().rotation
		follower_mug.unhide_self(self.get_sprite2D().tail)
		#the follower mug is NOT the player, so they do not get the player bit if that bit is set
		self.sync_mug_collision()
		
		if self.gravity < 5: self.gravity = 5
	
	#after following the trajectory we are no longer prepping jumps
	self.prepping_jump = false

func on_action_released(act : String)->void:
	
	#super.on_action_released(act)
	if do_jump_parabola and (act == "JUMP" or act == "ATTACK"):
		#prepare to follow trajectory
		self.prepping_jump = true
		get_sprite2D().custom_play("launch")

	if (self.state == CiderSpiritState.LAUNCHED or self.state == CiderSpiritState.SPLASHED) and (act == "JUMP" or act == "ATTACK"):
		wants_to_combine = false


func on_transform_animation_finished(anim):
	if anim == "walk_right":
		hop()
		
#used to indicate how we need to offset the sprite to make
#the splash on the collision point
@export var splash_location : Node2D

#ensures that our splash sprite is rotated correctly after a collision
func rotate_sprite_for_collision(col : KinematicCollision2D)->void:
	var normal = col.get_normal()
	
	#ensure that our sprite is located at the given global position
	var angle : float = normal.angle()
	self.get_sprite2D().rotation = angle + (PI if not self.get_sprite2D().flip_h else 0.0)
	
	#since we have an oblong sprite, we need to adjust it slightly on collision to ensure everything lines up
	self.get_sprite2D().position = self.original_sprite_position + normal * (1-cos(angle + PI/2))*50

func on_col(col : KinematicCollision2D)->void:
	if self.state == CiderSpiritState.LAUNCHED:
		self.state = CiderSpiritState.SPLASHED 
		if col:

			if col.get_collider().has_method("take_damage"):
				col.get_collider().take_damage(1)
			self.rotate_sprite_for_collision(col)
		else:
			self.get_sprite2D().rotation = PI/2 if self.velocity.x > 0 else -PI /2
		self.velocity.x = 0 #we hit the ground
		update_animation()
	elif self.state == CiderSpiritState.SPLASHED and col:
		self.rotate_sprite_for_collision(col)
	super.on_col(col)

func on_anim_finished():
	match get_sprite2D().animation:
		"fly":
			self.follow_trajectory()


func hide_follower_mug()->void:
	follower_mug.freeze           = true
	follower_mug.visible          = false 
	follower_mug.collision_layer  = 0
	follower_mug.collision_mask   = 0
	follower_mug.global_position  = global_position + Vector2(0,-20)

	wants_to_combine = false
	if self.global_transform.y.dot(follower_mug.global_transform.y) < 0:
		self.get_sprite2D().tail = "_down"
	self.state = EntityState.DEFAULT 
	self.velocity = Vector2(0,0)
	self.update_animation()

#collision shape that gets toggled when 
#we enter splash mode
@export var splash_collision : CollisionShape2D


func ensure_collision_rotation():
	pass
	#splash_collision.global_rotation = self.get_sprite2D().global_rotation - PI/2
#ensures that we have the correct
#collision shapes disabled or enabled
#for a given ciderspriit state
func update_collision()->void:
	#don't set anything until after we have setup the class
	if not splash_collision: return

	match self.state:
		CiderSpiritState.SPLASHED:
			#make sure that we are aligned to the sprite
			#self.ensure_collision_rotation()

			get_node("mainCollision").disabled = true
			splash_collision.disabled = false
			#get_node("launchCollision").disabled = true

		_:
			get_node("mainCollision").disabled = false
			splash_collision.disabled = true
			#get_node("launchCollision").disabled = true

#updates our collision layer so we can only be hit with possesion
#for use when we are splashed
func set_only_posses_collision()->void:
	self.collision_layer = ColMath.strip_bits(self.collision_layer,ColMath.Layer.NON_PLAYER_ENTITY)
	self.collision_layer |= ColMath.Layer.SIMPLE_ENTITY
	self.collision_mask = ColMath.strip_bits(self.collision_mask,ColMath.Layer.PLAYER)

func set_state(val)->void:
	#reset the position of the sprite in case some extra animations need to happen
	self.get_sprite2D().position = self.original_sprite_position

	if val == EntityState.DAMAGED: return

	if val == EntityState.DEFAULT:
		#reset the sprite rotation when we default our state
		self.get_sprite2D().rotation = 0
		self.velocity.x = 0
	#were JUMPIN'
	if val == CiderSpiritState.LAUNCHED:
		self.prepping_jump = false
	
	if val == CiderSpiritState.SPLASHED:
		#when splashed we can be possesed, but not collided with
		self.set_only_posses_collision()
	elif self.state != CiderSpiritState.LAUNCHED:
		self.collision_layer = self.gen_col_layer()
		self.collision_mask = self.gen_col_mask()

	super.set_state(val)
	
	#ensure that our hitbox matches the sprite
	self.update_collision()


func summon_mug()->void:
	wants_to_combine = true 
	if not follower_mug.freeze: return 

	#had a bit too much fun with vim multi curson on = :)
	self.sync_mug_collision()
	follower_mug.linear_velocity = (self.global_position-follower_mug.global_position).normalized()*follower_mug.initial_speed 
	var old_position             = follower_mug.global_position
	follower_mug.freeze          = false 
	follower_mug.global_position = old_position

	self.prepping_jump = false #if we are summoning the mug we are NOT prepping jump



func main_ready()->void:
	get_sprite2D().animation_finished.connect(self.on_anim_finished)
	transform_animation.animation_finished.connect(self.on_transform_animation_finished)
	super.main_ready()
	follower_mug = self.follower_mug_ps.instantiate()
	follower_mug.ciderSpirit = self
	await get_tree().physics_frame 
	self.original_sprite_position = self.get_sprite2D().position
	sync_mug_collision()
	add_sibling(follower_mug)
	hide_follower_mug()

#ensures that the follower mug has the proper collision layers
func sync_mug_collision()->void:
	follower_mug.collision_layer = ColMath.strip_bits(self.collision_layer,ColMath.ConstLayer.PLAYER) 
	follower_mug.collision_mask  = self.collision_mask

	self.prepping_jump = false


#ensure that we snyc the collision of the mug when leni posseses in and out
func posses_by(other):
	super.posses_by(other)
	if self.state == CiderSpiritState.PARABALA:
		self.do_jump_parabola = false
		self.state = EntityState.DEFAULT
	self.clear_stored_inputs()
	sync_mug_collision()

func exorcize(offset : Vector2 = Vector2(0,0))->void:
	super.exorcize(offset)
	
	sync_mug_collision()
	
	if self.state == CiderSpiritState.SPLASHED:
		self.set_only_posses_collision()


var hop_dir : String = ""
func hop()->void:
	match hop_dir:
		"LEFT":
			singal_move_and_collide(Vector2(-hop_distance,0))
			get_sprite2D().flip_h = true
		"RIGHT":
			singal_move_and_collide(Vector2(hop_distance,0))
			get_sprite2D().flip_h = false
			
func sigmoid(x)->float:
	var ex = exp(x)
	return ex / (ex+1)

func main_process(delta):
	if wants_to_combine and follower_mug.position.distance_squared_to(position) < combination_threshold**2:
		hide_follower_mug()
	
	if do_jump_parabola:
		jump_time += self.parabala_target_speed*delta 
		jump_distance = sin(-jump_time if get_sprite2D().flip_h else jump_time)*max_jump.x
		jump_height = (sigmoid(jump_distance*jump_distance/90000)-0.5)**2*max_jump.y*4
		self.queue_redraw()
	if self.state == CiderSpiritState.LAUNCHED:
			
		get_sprite2D().rotation = atan2(self.velocity.y,
											self.velocity.x*self.speed.x) + (PI if get_sprite2D().flip_h else 0.0)
		#get_sprite2D().look_at(Vector2(0,
	super.main_process(delta)
		
		
#returns the y value of a parabola
#that starts from our character position, ends on distance, and goes up to max_height
#this is inteanded for drawing trajectories
func get_parabola_height(x,distance,max_height)->float:
	return 4*max_height*(x*x-x*distance)/(distance*distance)

#gets the derivative of the parabola for dealing with line squishification
func get_parabola_derivative(x,distance,max_height)->float:
	return 4*max_height*(2*x-distance)/( distance*distance )

func on_action_press(action : String)->void:
	if action == "LEFT" or action == "RIGHT":
		hop_dir = action 	
	if action == "ATTACK":
		self.jump()
	super.on_action_press(action)

func draw_parabala(
	height : float,
	distance : float,
	offset : Vector2 = Vector2.ZERO,
	segments : int = 100,
	window : float = 0,
	w_size : float=10)->void:

	if distance < 0:
		offset.x += distance
		distance = -distance
	var seg_length = distance / segments 
	for i in range(segments):
		if  abs(fmod(i*seg_length-window,w_size))  < w_size/5:
			var current_point : Vector2 = Vector2(i*seg_length,get_parabola_height(i,distance,height)) + offset
			var next_point : Vector2 = Vector2((i+1)*seg_length,get_parabola_height(i,distance,height)) + offset 
			var squishification : float = get_parabola_derivative(i*seg_length,distance,height) #derivative for squishing line
			
			draw_line(
				current_point,
				next_point,
				Color.BLACK,
				clamp(abs(2*squishification),1,3) #scale the width by the derivative
				,true
				)
func _draw():
	if do_jump_parabola:
		draw_parabala(
				jump_height,
				jump_distance,
				parabola_position.position,
				abs(floor(jump_distance)),
				abs(sin(jump_time))*jump_distance,
				10,
			)
func update_animation()->void:
	if self.state == CiderSpiritState.SPLASHED:
		self.get_sprite2D().custom_play("splash")
	elif self.state != CiderSpiritState.PARABALA:
		super.update_animation()
		self.get_sprite2D().flip_h = self.hop_dir == "LEFT"
