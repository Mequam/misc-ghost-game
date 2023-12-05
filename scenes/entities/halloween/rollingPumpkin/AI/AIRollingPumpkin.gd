extends EntityAI

class_name AIPumpkinFollow

#very simple AI where the pumpkin simply follows the player
@export var aggro_range : float = 800
@export var aggro_height : float = 100 #triggers if we have a given height distance from the player

#move twoards the player
func tick(player : Entity)->void:
	print_debug(abs(player.global_position.y - self.caller.global_position.y))
	if player.global_position.distance_squared_to(self.caller.global_position) < self.aggro_range*self.aggro_range \
			and abs(player.global_position.y - self.caller.global_position.y) < self.aggro_height:
		if player.global_position.x < self.caller.global_position.x:
			self.caller.perform_action("LEFT",true)
			self.caller.perform_action("RIGHT",false)
		else:
			self.caller.perform_action("LEFT",false)
			self.caller.perform_action("RIGHT",true)

