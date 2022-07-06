extends RespawnLamp
#this class is the orchard lamp respawn light

class_name OrchardLamp

#this light uses the parents name as the respawn object in the main scene
func gen_respawn_name()->String:
	return get_parent().name + "/" + .gen_respawn_name()
