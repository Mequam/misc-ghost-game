extends Npc

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

enum RotatingPumkinState {
	EXPLOADING = Entity.ENTITY_STATE_COUNT
}
func add_impulse(force : Vector2)->void:
	net_force += force 

func on_action_press(action : String)->void:
	if action == "JUMP" and self.onground:
		#we jump higher if we move FASTER
		#give up control for height
		self.velocity.y = -clamp(self.jump_speed*abs(self.velocity.x),jump_min,jump_max) 
	elif action == "ATTACK":
		self.state = RotatingPumkinState.EXPLOADING
		self.get_sprite2D().custom_play("expload")
	super.on_action_press(action)

#uses player input to compute net force on the body
func compute_force()->Vector2:
	var ret_val : Vector2 = Vector2(0,0)
	for act in self.pressed_inputs:
		if self.pressed_inputs[act]: ret_val += action2velocity(act)
	return ret_val*player_control
		

func _physics_process(delta)->void:
	if not self.state == RotatingPumkinState.EXPLOADING:
		self.velocity += (compute_force() + gravity-self.velocity*friction)*delta 

		#have x and y terminal velocity seperate to avoid oddities on jump
		if abs(velocity.x) > self.terminal_velocity.x:
			self.velocity.x = self.terminal_velocity.x * (-1 if self.velocity.x < 0 else 1)
		if abs(self.velocity.y) > self.terminal_velocity.y:
			self.velocity.y = self.terminal_velocity.y * (-1 if self.velocity.y < 0 else 1)
		
		var col = self.singal_move_and_collide(self.velocity*delta)
		if col:	
			var normal : Vector2 = col.get_normal()
			var projection : Vector2 = self.velocity.project(normal)
			self.velocity -= projection
			self.singal_move_and_collide(self.velocity*delta) #slide after colliding
			
			#updtae the rotation speed and send normal information to the animation system
			self.get_sprite2D().rotation_speed = self.velocity.length()*(-1 if self.velocity.x < 0 else 1)
			if self.get_sprite2D().ouch_threshold < projection.length():
				self.get_sprite2D().custom_play("ouch")

	

func main_ready()->void:
	self.get_sprite2D().animation_finished.connect(self.anim_finished)
	super.main_ready()

func anim_finished(anim : StringName)->void:
	match anim:
		"roll_prep":
			self.velocity += Vector2(10 * (-1 if self.velocity.x < 0 else 1),-20) #quick boost to velocity after the pumpkin "thrusts"

func main_process(delta)->void:
	super.main_process(delta)
