extends Entity

class_name LRJEntity #Left Right Jump Entity

#this is a class of entity that is moved around ising left right and jump

@export var jr : JumpResource

#how fast we fall to the ground
var gravity : float = speed.y/2
var run : bool = false #wether or not we are running

#controls how fast we walk
@export var walk_speed : Vector2 = Vector2(50,50)
@export var run_modifier : float = 4
@export var do_fast_fall : bool = true

func main_ready():
	self.onground = false
	super.main_ready()

func clear_stored_inputs():
	run = false
	super.clear_stored_inputs()

func on_ground_changed(val : int)->void:
	super.on_ground_changed(val)
	if self.onground:
		self.velocity.y = 0
	
	#trigger an animation update
	self.update_animation()

func on_action_double_press(act : String)->void:
	if act == "LEFT" or act == "RIGHT":
		run = true
	super.on_action_double_press(act)
func on_action_released(act : String)->void:
	if act == "LEFT" or act == "RIGHT":
		run = false
	if act == "JUMP":
		gravity = jr.get_down_gravity()
	super.on_action_released(act)

func jump()->void:
	if self.onground:
		self.velocity = Vector2(0,-(jr as JumpResource).get_initial_up_speed())
		self.gravity = (jr as JumpResource).get_up_gravity()
		get_sprite2D().custom_play("jump")

func on_action_press(act : String)->void:
	match act:
		"JUMP":
			jump()
	super.on_action_press(act)

func compute_velocity(velocity : Vector2)->Vector2:
	if pressed_inputs["RIGHT"]:
		velocity += Vector2(1,0)
	if pressed_inputs["LEFT"]:
		velocity -= Vector2(1,0)
	if run:
		velocity.x *= run_modifier 
	velocity *= walk_speed
	return super.compute_velocity(velocity)

func update_animation()->void:
	if state != EntityState.DAMAGED:
		var computed_vel : Vector2 = compute_velocity(velocity)
		if computed_vel == Vector2(0,0):
			get_sprite2D().custom_play("idle")

		elif computed_vel.y > 0 and get_sprite2D().animation != "fall":
			get_sprite2D().custom_play("fall_start")
		elif self.onground and not pressed_inputs["JUMP"] and abs(computed_vel.x) > 0:
			get_sprite2D().custom_play("walk_right")
		
		if get_sprite2D().animation != "idle":
			get_sprite2D().flip_h = computed_vel.x < 0
		
	super.update_animation()

#we fall when we are in the air
func main_process(delta):
	if not self.onground and not state == EntityState.BRICK: 
		if do_fast_fall and abs(velocity.y) < 0.1: #if we reach peak height, fall down
			gravity = jr.get_down_gravity()
		velocity.y += gravity*delta
		update_animation()
	super.main_process(delta)
