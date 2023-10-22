extends Entity
#non player character class that every non player
#entity derives from

class_name Npc

#this is a reference to an evil ghost, if set
#we spawn an evil ghost when Leni Posseses us
#var evil_possesion : EvilGhost = null :
#	get:
#		return evil_possesion # TODOConverter40 Copy here content of get_evil_possesion
#	set(mod_value):
#		mod_value  # TODOConverter40 Copy here content of set_evil_possesion
#func set_evil_possesion(val : EvilGhost)->void:
#	if val:
#		if evil_possesion:
#			eject_evil_ghost()
#		evil_possesion = val
#		get_sprite2D().material = possesed_material
#		get_sprite2D().material.set_shader_parameter("color",val.glow_color)
#		if val.get_parent():
#			val.get_parent().remove_child(val)
#func get_evil_possesion()->EvilGhost:
#	return evil_possesion
#
#func eject_evil_ghost():
#	return
#	if evil_possesion:
#		add_to_parent_at(evil_possesion,global_position)
#		evil_possesion.state = EvilGhost.EvilGhostState.JUST_SPAWNED
#		evil_possesion = null
#		possesed_material.set_shader_parameter("color",Color(0,1,1))
#		if not possesed:
#			get_sprite2D().material = null

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

func main_ready():
	self.possesed = false
	add_to_group("Npc")
	super.main_ready()
func set_possesed(val : bool)->void:
	super.set_possesed(val)
func die():
	super.die()
