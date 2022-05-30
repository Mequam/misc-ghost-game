extends Entity
#non player character class that every non player
#entity derives from

class_name Npc

var possesed_material : ShaderMaterial
func main_ready():
	possesed_material = ResourceLoader.load("res://assets/shaders/possesed.tres")
	.main_ready()
func set_possesed(val : bool)->void:
	if val:
		$Sprite.material = possesed_material
	else:
		$Sprite.material = null
	.set_possesed(val)
