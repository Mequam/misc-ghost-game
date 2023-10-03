extends EntityAI

class_name LRJEntityAI


func ai_run_away(player):
	if player.position.x < caller.position.x:
		perform_action("RIGHT",true,true)
	else:
		perform_action("LEFT",true,true)

#convinence functions for the AI of an NPC
#these obviously wont be used everywhere, but they
#will speed up development for 90% of NPcs

#to look at the players position
func ai_look_at_player(player):
	if player.position.x < caller.position.x:
		perform_action("RIGHT",false)
		perform_action("LEFT",true)
		perform_action("LEFT",false)
	else:
		perform_action("LEFT",false)
		perform_action("RIGHT",true)
		perform_action("RIGHT",false)

func ai_attack_at_player(player):
	ai_look_at_player(player)
	perform_action("ATTACK",true)
	perform_action("ATTACK",false)
