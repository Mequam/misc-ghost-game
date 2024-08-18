extends EnvironEntity

class_name RespawnLamp


@export var max_leni_life : bool = true

@export var background_z_index : int = -1
@export var forground_z_index : int = 0


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
	get_main().clear_runtime_variables()
	self.z_index = self.forground_z_index

	super.posses_by(entity)
	pass

func exorcize(offset : Vector2 = Vector2(0,0))->void:
	self.z_index = self.background_z_index
	super.exorcize(offset)
