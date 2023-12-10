extends DumbyEntity

#this class is for entities that are part of the environment
#and do NOT take damage
#mostly just a convience class for quickly creating convinent possesors

class_name EnvironEntity

func take_damage(amount : int = 0, source = null)->void:
	pass
