extends LRJEntityAI 

class_name WitchShootRunAI 

#this script is an AI for the witch entity
#that shoots at Leni, and then runs the column attack
#and runs away if he gets close


#internal timer to space out attacks by fours
#that way we are a LITTLE slower than the game Ai timer
var ai_ticks : int = 0

func ai_fire_column():
	perform_action("UP",true)
	perform_action("ATTACK",true)
	perform_action("ATTACK",false)
	perform_action("UP",false)

func ai_shoot_col(player):
	ai_look_at_player(player)
	ai_fire_column()

func ai_shoot_projectile_dir(dir : String)->void:
	perform_action(dir,true,true)
	perform_action("ATTACK",true)
	perform_action(dir,false)

func ai_shoot_projectile(player):
	if player.position.x < caller.position.x:
		ai_shoot_projectile_dir("LEFT")
	else:
		ai_shoot_projectile_dir("RIGHT")
	
func tick(player : Entity)->void:

	print("")
	print("AI_TICK")
	print(player.position)
	print("")

	if caller.run:
		if abs(player.position.x - caller.position.x) > 200:
			perform_action("LEFT",false)
			perform_action("RIGHT",false)
	elif abs(player.position.x - caller.position.x) < abs(caller.get_node("col_spawn_position").position.x):
		ai_shoot_col(player)
		ai_run_away(player)
	else:
		if ai_ticks == 4:
			ai_shoot_projectile(player)
	ai_ticks += 1
	ai_ticks = ai_ticks % 5
