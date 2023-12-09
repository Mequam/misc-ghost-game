extends DumbyEntity

class_name RespawnLamp


@export var max_leni_life : bool = true
#the life that leni respawns in with
func get_start_health(leni : Leni)->int:
	if max_leni_life:
		return leni.max_health
	return self.health

func posses_by(entity)->void:
	GameLoader.save_game_from_lamp(self)
	get_main().runtime_variables.clear()
	super.posses_by(entity)

