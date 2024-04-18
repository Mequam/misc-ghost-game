extends Entity

#non player character class that every non player
#entity derives from

#while these guys can still be possesed, possesing them
#often does different stuff from the possesions that were used to
#and they offer minimal motion and combat abilities

class_name Npc

func gen_col_layer()->int:
	return ColMath.Layer.SIMPLE_ENTITY
func gen_col_mask()->int:
	return ColMath.ConstLayer.TILE_BORDER | ColMath.Layer.TERRAIN

func main_ready():
	add_to_group("Npc")
	super.main_ready()
