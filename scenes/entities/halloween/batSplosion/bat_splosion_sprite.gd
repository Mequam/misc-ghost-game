extends AnimatedSprite2D



#this is for things like shaking and positional movement
#that we want to interpolate
@export var animation_player : AnimationPlayer

#node 2d that contains our sound effects as children
@export var sound_effects : Node2D

func get_entity_parent()->Entity:
	var p = get_parent()
	while not p is Entity:
		p = p.get_parent()
	return p

#returns true if the parent wishes to expload currently
func check_parent_expload()->bool:
	return get_entity_parent().pressed_inputs["ATTACK"]

func custom_play(anim : String)->void:
	if animation == "no_return": return
	if animation == "fall" and get_entity_parent().state == BatSplosion.BatSplosionState.HANGING: return
	if anim == "hang":
		self.play_backwards("fall")
		return


	if anim == "expload":
		if animation == "expload": #we were already undoing explosions
			print_debug("playing bubble effect")
			self.sound_effects.get_node("bubbleEffect").play()
		else: #first time exploader
			self.sound_effects.get_node("fuseEffect").play()

	if animation == "expload":
		match anim:
			"unexpload":
				self.play_backwards("expload")
				self.sound_effects.get_node("bubbleEffect").stop()
				self.sound_effects.get_node("hissEffect").play()

				#self.sound_effects.get_node("bubbleEffect").stop()
			"expload":
				animation_player.play("expload2")
				self.sound_effects.get_node("bubbleEffect").play()
				self.sound_effects.get_node("hissEffect").stop()
				self.play("expload")
				#start the bubble sound effect
	else:
		self.play(anim)

func _ready()->void:
	self.animation_finished.connect(self.on_anim_finished)
	self.animation_looped.connect(self.on_anim_looped)
	self.animation_player.animation_finished.connect(self.on_player_finished)
	self.sound_effects.get_node("fuseEffect").finished.connect(self.on_fuse_effect_finished)

func on_fuse_effect_finished()->void:
	self.sound_effects.get_node("bubbleEffect").play()

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
		self.sound_effects.get_node("explosionEffect").play() #time to die
		self.animation_player.play("bigsplosion")
