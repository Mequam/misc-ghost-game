extends AnimatedSprite2D

func _ready()->void:
	self.animation_finished.connect(self.on_anim_finished)

func on_anim_finished()->void:
	match self.animation:
		"turn":
			self.custom_play("idle")

func custom_play(anim : StringName = "",backwords : bool = false)->void:
	play(anim,1,backwords)
