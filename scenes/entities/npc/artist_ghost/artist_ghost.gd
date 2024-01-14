extends Npc

class_name ArtistGhost

func gen_col_layer()->int:
	return ColMath.Layer.SIMPLE_ENTITY
func gen_col_mask()->int:
	return ColMath.ConstLayer.TILE_BORDER | ColMath.Layer.TERRAIN

#we take NO damage
func take_damage(amount : int = 0, source = null)->void:
	pass

func posses_by(ghost)->void:
	super.posses_by(ghost)
	self.z_index = 0

func exorcize(offset : Vector2 = Vector2(0,0))->void:
	super.exorcize(offset)
	self.z_index = -1 #go back to bieng behind the player

