extends LRJEntity

class_name CiderSpirit


@export var hop_distance : float = 10
@export var max_jump : Vector2 = Vector2(40,30)

@export var transform_animation : AnimationPlayer
@export var parabola_position : Node2D 
@export var parabala_target_speed : float = 100


#controls how many different segments of the parabola that we draw
@export var parabala_segments : int = 4

#used when computing the time it takes us to travel a given distance via jump parabola
@export var jump_speed : float = 10


enum CiderSpiritState {
	PARABALA = Entity.ENTITY_STATE_COUNT,
	LAUNCHED
}

var jump_time : float = 0
var jump_distance : float = 0
var jump_height : float = 0

var do_jump_parabola : bool = false  :
	set(val):
		do_jump_parabola = val 
		jump_time = 0
		self.state = CiderSpiritState.PARABALA
		queue_redraw()
	get:
		return do_jump_parabola

#when we would normaly jump, we prepare to
#parabala leep
func jump()->void:
	self.do_jump_parabola = true 

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
func on_action_released(act : String)->void:
	#super.on_action_released(act)
	if do_jump_parabola and act == "JUMP":
		#prepare to follow trajectory
		get_sprite2D().custom_play("launch")


func on_transform_animation_finished(anim):
	if anim == "walk_right":
		hop()
		

func on_col(col : KinematicCollision2D)->void:
	if self.state == CiderSpiritState.LAUNCHED:
		self.state = EntityState.DEFAULT 

		var normal = col.get_normal()
		if 5*abs(normal.y) > abs(normal.x): #we hit the ground
			self.velocity.x = 0 #we hit the ground
	super.on_col(col)
func on_anim_finished():
	match get_sprite2D().animation:
		"fly":
			self.follow_trajectory()

func main_ready()->void:
	get_sprite2D().animation_finished.connect(self.on_anim_finished)
	transform_animation.animation_finished.connect(self.on_transform_animation_finished)
	super.main_ready()

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
	if do_jump_parabola:
		jump_time += self.parabala_target_speed*delta 
		jump_distance = sin(-jump_time if get_sprite2D().flip_h else jump_time)*max_jump.x
		jump_height = (sigmoid(jump_distance*jump_distance/90000)-0.5)**2*max_jump.y*4
		self.queue_redraw()
	if self.state == CiderSpiritState.LAUNCHED:
		var sprite_parent = get_sprite2D().get_parent()
		print(self.velocity.angle())
		print(sprite_parent.rotation)
		sprite_parent.look_at(sprite_parent.global_position + self.velocity)
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
			var squishification : float =get_parabola_derivative(i*seg_length,distance,height) #derivative for squishing line
			
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
	if self.state != CiderSpiritState.PARABALA:
		super.update_animation()
	pass
