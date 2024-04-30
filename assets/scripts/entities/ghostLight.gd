extends EnvironEntity

class_name RespawnLamp


@export var max_leni_life : bool = true

func gen_col_layer()->int:
	return ColMath.Layer.SIMPLE_ENTITY
func gen_col_mask()->int:
	return ColMath.ConstLayer.TILE_BORDER | ColMath.Layer.TERRAIN

#the life that leni respawns in with
func get_start_health(leni : Leni)->int:
	if max_leni_life:
		return leni.max_health
	return self.health

func posses_by(entity)->void:
	GameLoader.save_game_from_lamp(self)
	get_main().runtime_variables.clear()
	self.z_index = 0

	super.posses_by(entity)
	pass

func exorcize(offset : Vector2 = Vector2(0,0))->void:
	self.z_index = -1
	super.exorcize(offset)
