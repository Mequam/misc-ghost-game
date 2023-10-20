extends LRJEntityAI 

class_name AICiderSpirit_JumpOver


#controls the frequency that we jump at the player
@export var ai_timer_jump : Timer 

func tick(player)->void:
	if not ai_timer_jump.wait_time <= 0 and caller.pressed_inputs["JUMP"] and caller.state == caller.EntityState.DEFAULT:
		caller.perform_action("JUMP",false)
	else:
		if caller.position.distance_squared_to(player.position) < 600**2 and caller.state != caller.CiderSpiritState.LAUNCHED:
				ai_look_at_player(player)
				ai_jump_past_player(player)
		if caller.state == caller.CiderSpiritState.SPLASHED:
			#start the timer for the next time that we can jump
			ai_timer_jump.start()
			caller.perform_action("JUMP",true)


#trys to jump past the player
func ai_jump_past_player(player,error : float=100)->void:
	if not caller.pressed_inputs["JUMP"]: 
		caller.perform_action("JUMP",true)
	var target = (player.position.x - caller.position.x)*2
	if (caller.jump_distance  < target + error and caller.jump_distance > target - error):
		#we are at a valid distance, jump!
		caller.perform_action("JUMP",false)
