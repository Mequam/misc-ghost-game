extends Entity
#non player character class that every non player
#entity derives from

class_name Npc

#convinence functions for the AI of an NPC
#these obviously wont be used everywhere, but they
#will speed up development for 90% of NPcs

#to look at the players position
func ai_look_at_player(player):
	if player.position.x < position.x:
		perform_action("RIGHT",false)
		perform_action("LEFT",true)
		perform_action("LEFT",false)
	else:
		perform_action("LEFT",false)
		perform_action("RIGHT",true)
		perform_action("RIGHT",false)

func ai_attack_at_player(player):
	ai_look_at_player(player)
	perform_action("ATTACK",true)
	perform_action("ATTACK",false)

var possesed_material : ShaderMaterial
func main_ready():
	possesed_material = ResourceLoader.load("res://assets/shaders/possesed.tres")
	self.possesed = false
	add_to_group("Npc")
	.main_ready()
func set_possesed(val : bool)->void:
	if val:
		$Sprite.material = possesed_material
	else:
		$Sprite.material = null
	.set_possesed(val)
