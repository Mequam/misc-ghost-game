extends TextureButton

#this class represents a pip that the player can click on in
#order to summon an unlocked entity in the summon menu

class_name SummonMenuIndicator


#texture that represents the entity that we are summoning
@export var entity_texture : Texture
#the entity that we want to summon
@export var entity_to_summon : PackedScene

#finds the summon menu or dies trying
func get_summon_menu()->SummonMenu:
	var p = get_parent()
	while not p is SummonMenu:
		p = p.get_parent()
	return p


#determines if this power up is unlocked or not
func is_unlocked()->bool:

	if not GameLoader.game_data: 
		print_debug("not unlocked")
		return false

	for game in GameLoader.game_data.unlocked_summons:
		if game == self.name:
			print_debug(self.name + " I should be unlocked")
			return true

	print_debug("not unlocked")
	return false

#configures our display to match if we are currently unlocked or not
func display_unlocked()->void:
	var unlocked = self.is_unlocked()
	self.material.set_shader_parameter("doSilloette",not unlocked)
	if not unlocked:
		print_debug("we are not unlocked")
		return

func _ready() -> void:
	self.mouse_entered.connect(self.on_mouse_entered)
	self.mouse_exited.connect(self.on_mouse_exited)
	self.pressed.connect(self.on_pressed)
	get_node("summon_star/AnimationPlayer").animation_finished.connect(self.on_animation_finished)

func on_animation_finished(anim)->void:
	if anim == "summon_start":
		get_node("summon_star/AnimationPlayer").play("rotate_star")

func on_mouse_entered()->void:
	#indicate that we want to summon this entity
	if not self.is_unlocked(): return

	self.get_summon_menu().indicate(self)
	get_node("summon_star/AnimationPlayer").play("summon_start")

func on_mouse_exited()->void:
	if not self.is_unlocked(): return

	self.get_summon_menu().unindicate()
	get_node("summon_star/AnimationPlayer").play("summon_stop")
func on_pressed()->void:
	if not self.is_unlocked(): return
	self.get_summon_menu().summon(self)
