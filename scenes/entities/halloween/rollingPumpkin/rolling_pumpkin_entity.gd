extends Npc

#this class represents the rotating pumkin enemy

class_name RotatingPumpkin 

@export var gravity : Vector2 #gravity pulling the physics possesion
@export var net_force : Vector2 #net force set by the player
@export var player_control : Vector2

#the delta time allowed for an impulse to take effect,
#in seconds
@export var impulse_delta : float = 0.1

@export var impulse_data : LinkedList

func add_impulse(force : Vector2)->void:
	net_force += force 
	self.impulse_data.add_data_to_list([force,Time.get_ticks_msec()])



func update_impulses()->void:
	impulse_data.foreach(
		func (node):
			var delta_time =Time.get_ticks_msec() - node[0][1] 
			print(delta_time)
			if  delta_time > self.impulse_delta:
				self.net_force -= node[0][0]
				self.impulse_data.remove_node_from_list(node)
	)

func on_action_press(action : String)->void:
	self.add_impulse(self.action2velocity(action)*player_control) #convert the action into an appropriate velocity
	super.on_action_press(action)

func _physics_process(delta)->void:
	self.velocity += (net_force + gravity)*delta 
	self.singal_move_and_collide(self.velocity*delta)
	self.update_impulses()

func main_process(delta)->void:
	super.main_process(delta)
