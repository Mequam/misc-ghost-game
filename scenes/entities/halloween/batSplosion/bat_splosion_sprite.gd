extends AnimatedSprite2D


#store wether or not we need to transition
#into an exploasion
var set_expload : bool = false

#this is for things like shaking and positional movement
#that we want to interpolate
@export var animation_player : AnimationPlayer

func custom_play(anim : String)->void:
	match anim:
		"expload":
			animation_player.play("expload")
			self.set_expload = true
		"idle":
			self.play(anim)

func _ready()->void:
	self.animation_looped.connect(self.on_anim_looped)

func on_anim_looped()->void:
	print_debug("looped animation!")
	match self.animation:
		"idle":
			if self.set_expload:
				self.play("expload")

