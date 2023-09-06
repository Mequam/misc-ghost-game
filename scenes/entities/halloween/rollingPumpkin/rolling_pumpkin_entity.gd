extends Npc

#this class represents the rotating pumkin enemy

class_name RotatingPumpkin 

@export var gravity : Vector2 #gravity pulling the physics possesion
@export var net_force : Vector2 #net force set by the player
@export var player_control : Vector2

@export var terminal_velocity : float 
@export var friction : Vector2 #friction proportionality constant 0 is no friction 1 is infinit friction

@export var jump_speed : float

func add_impulse(force : Vector2)->void:
	net_force += force 

func on_action_press(action : String)->void:
	if action == "JUMP" and self.onground:
		self.velocity.y = -self.jump_speed 
	self.net_force += self.action2velocity(action)*player_control #convert the action into an appropriate velocity
	super.on_action_press(action)

func on_action_released(action : String)->void:
	self.net_force -= self.action2velocity(action)*player_control
	super.on_action_released(action)

func _physics_process(delta)->void:
	self.velocity += (net_force + gravity-self.velocity*friction)*delta 
	if velocity.length() > self.terminal_velocity:
		self.velocity = self.velocity.normalized()*self.terminal_velocity
	var col = self.singal_move_and_collide(self.velocity*delta)
	if col:	
		self.velocity -= self.velocity.project(col.get_normal())
		self.singal_move_and_collide(self.velocity*delta) #slide after colliding

func main_process(delta)->void:
	super.main_process(delta)
