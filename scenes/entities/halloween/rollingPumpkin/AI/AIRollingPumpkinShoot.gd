extends AIPumpkinFollow

class_name AIRollingPumpkinShoot

#how close to the player do we get before we start 
#jumping
@export var jump_distance : float
@export var jump_cooldown_time : int = 5

#used to determine how long we wait before we jump
var jump_timer : int = 0

func tick(player : Entity)->void:
	if jump_timer >= jump_cooldown_time and \
			self.caller.global_position.distance_squared_to(player.global_position) < self.jump_distance*self.jump_distance:
		
			self.caller.perform_action("ATTACK",false)
			self.caller.perform_action("ATTACK",true)
			jump_timer = 0

	#tick up the time until we are ready to jump again
	jump_timer += 1
	super.tick(player)

