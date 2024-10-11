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


func is_unlocked()->bool:
	return GameLoader.game_data and self.name in GameLoader.game_data.unlocked_summons

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


func on_mouse_entered()->void:
	#indicate that we want to summon this entity
	self.get_summon_menu().indicate(self)
func on_mouse_exited()->void:
	pass
func on_pressed()->void:
	self.get_summon_menu().summon(self)
