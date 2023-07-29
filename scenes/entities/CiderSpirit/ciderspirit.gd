extends LRJEntity

class_name CiderSpirit


@export var hop_distance : float = 10
@export var max_jump : Vector2 = Vector2(40,30)

@export var transform_animation : AnimationPlayer
@export var parabola_position : Node2D 
@export var parabala_target_speed : float = 100


#controls how many different segments of the parabola that we draw
@export var parabala_segments : int = 4


var jump_time : float = 0
var jump_distance : float = 0
var jump_height : float = 0

var do_jump_parabola : bool = false  :
	set(val):
		do_jump_parabola = val 
		jump_time = 0
	get:
		return do_jump_parabola

func jump()->void:
	print("calling the jump function")
	self.do_jump_parabola = true

func on_action_released(act : String)->void:
	if do_jump_parabola:
		super.jump()
	super.on_action_released(act)

func on_transform_animation_finished(anim):
	if anim == "walk_right":
		hop()

func main_ready()->void:
	transform_animation.animation_finished.connect(self.on_transform_animation_finished)
	super.main_ready()
var hop_dir : String = ""
func hop()->void:
	match hop_dir:
		"LEFT":
			singal_move_and_collide(Vector2(-hop_distance,0))
		"RIGHT":
			singal_move_and_collide(Vector2(hop_distance,0))
			
#func draw_parabala_from_parent()->void:
#	var xfinal = 2*position[0] #the final position of the parabala
#	var last_point : float = 0
#	for i in range(0,parabala_segments):
#		#half our required computation by caching each point as apposed to recomputing
#		var current_point = float(i)*xfinal/float(parabala_segments)
#		draw_line_at_parent(Vector2(last_point,jump_parabala_path(last_point)),Vector2(current_point,jump_parabala_path(current_point)),Color.RED)
#		last_point = current_point
func sigmoid(x)->float:
	var ex = exp(x)
	return ex / (ex+1)
func main_process(delta):
	if do_jump_parabola:
		jump_time += self.parabala_target_speed*delta 
		jump_distance = cos(jump_time)*max_jump.x
		jump_height = (sigmoid(jump_distance*jump_distance/90000)-0.5)**2*max_jump.y*4
		self.queue_redraw()
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
	print(seg_length)
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
	draw_parabala(
			jump_height,
			jump_distance,
			parabola_position.position,
			abs(floor(jump_distance)),
			abs(cos(jump_time))*jump_distance,
			10,
			)
