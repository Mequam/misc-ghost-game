extends Entity
#TODO:
#this class should really be taken out, or at least expanded upon as
#its not doing much atm

#non player character class that every non player
#entity derives from

class_name Npc

func main_ready():
	self.possesed = false
	add_to_group("Npc")
	super.main_ready()
