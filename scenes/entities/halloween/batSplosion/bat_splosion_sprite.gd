extends AnimatedSprite2D



#this is for things like shaking and positional movement
#that we want to interpolate
@export var animation_player : AnimationPlayer

func get_entity_parent()->Entity:
	var p = get_parent()
	while not p is Entity:
		p = p.get_parent()
	return p

#returns true if the parent wishes to expload currently
func check_parent_expload()->bool:
	return get_entity_parent().pressed_inputs["ATTACK"]

var exploading : bool
func custom_play(anim : String)->void:
	if animation == "no_return": return
	if animation == "fall" and get_entity_parent().state == BatSplosion.BatSplosionState.HANGING: return
	if anim == "hang":
		self.play_backwards("fall")
		return

	exploading = anim == "expload"
	

	if animation == "expload":
		var current_frame = self.frame
		match anim:
			"unexpload":
				self.play_backwards("expload")
				self.frame = current_frame
			"expload":
				animation_player.play("expload2")
				self.play("expload")
				self.frame = current_frame
	else:
		self.play(anim)

func _ready()->void:
	self.animation_finished.connect(self.on_anim_finished)
	self.animation_looped.connect(self.on_anim_looped)
	self.animation_player.animation_finished.connect(self.on_player_finished)
func on_anim_looped()->void:
	pass 
func on_player_finished(anim : StringName)->void:
	match anim:
		"bigsplosion":
			self.get_entity_parent().die()
#make sure that we play the correct animation after exploading
func on_anim_finished()->void:
	if not self.check_parent_expload() and self.animation == "expload":
		animation_player.stop()
		self.play("idle")
	elif self.animation == "expload":
		self.play("no_return")
	elif self.animation == "fall":
		if self.get_entity_parent().state != BatSplosion.BatSplosionState.HANGING:
			self.play("idle")
		else:
			self.play("hang")
	elif self.animation == "no_return":
		self.animation_player.play("bigsplosion")
