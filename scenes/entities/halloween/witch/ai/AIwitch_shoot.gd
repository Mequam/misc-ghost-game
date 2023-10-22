extends WitchShootRunAI 

class_name WitchShootAI

#simple ai for the witch that only shoots at the player
func tick(player : Entity)->void:
	if ai_ticks == 0:
		ai_shoot_projectile(player)
	
	ai_ticks += 1
	ai_ticks = ai_ticks % 5
