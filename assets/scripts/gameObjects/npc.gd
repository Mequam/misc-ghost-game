extends Entity
#non player character class that every non player
#entity derives from

class_name Npc


func set_possesed(val : bool)->void:
	$Sprite.material.set_shader_param("possesed",val)
	.set_possesed(val)
