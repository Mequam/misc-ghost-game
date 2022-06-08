extends Entity
#non player character class that every non player
#entity derives from

class_name Npc

#this is a reference to an evil ghost, if set
#we spawn an evil ghost when Leni Posseses us
var evil_possesion : EvilGhost = null setget set_evil_possesion,get_evil_possesion
func set_evil_possesion(val : EvilGhost)->void:
	if val:
		if evil_possesion:
			eject_evil_ghost()
		evil_possesion = val
		$Sprite.material = possesed_material
		$Sprite.material.set_shader_param("color",val.glow_color)
		if val.get_parent():
			val.get_parent().remove_child(val)
func get_evil_possesion()->EvilGhost:
	return evil_possesion

func eject_evil_ghost():
	if evil_possesion:
		add_to_parent_at(evil_possesion,global_position)
		evil_possesion.state = EvilGhost.EvilGhostState.JUST_SPAWNED
		evil_possesion = null
		possesed_material.set_shader_param("color",Color(0,1,1))
		if not possesed:
			$Sprite.material = null

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
	possesed_material = ResourceLoader.load("res://assets/shaders/possesed.tres").duplicate()
	self.possesed = false
	add_to_group("Npc")
	.main_ready()
func set_possesed(val : bool)->void:
	if val:
		$Sprite.material = possesed_material
	else:
		$Sprite.material = null
	.set_possesed(val)
	
	if val:
		eject_evil_ghost()
func die():
	eject_evil_ghost()
	.die()
