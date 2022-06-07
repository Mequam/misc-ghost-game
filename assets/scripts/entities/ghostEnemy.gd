extends FlightEntity
#this class is the generic class for the evil ghosts
#that posses things and get kicked out of possesion other than Leni

class_name EvilGhost

#every ghost has a possesion color 
#that the game uses to know when it is possesed
var glow_color : Color = Color(0.5,1,0.58)

#we are NEVER possesed because we are a ghost no :D
func set_possesed(val : bool)->void:
	val = false

#overshadows the given entity
#NOTE:
#this is much less invasive than Lenis Possesion
#basically this just makes the given entity glow and spawn a ghost when
#it dies
func posses(entity_to_posses)->void:
	pass
