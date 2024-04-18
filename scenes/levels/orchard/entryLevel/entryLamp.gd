extends RespawnLamp

func posses_by(entity):
	$DisapearingLabel/AnimationPlayer.play("TutorialText")
	self.z_index = 0
	super.posses_by(entity)

func exorcize(offset : Vector2 = Vector2(0,0))->void:
	self.z_index = -1
	$DisapearingLabel/AnimationPlayer.play_backwards("TutorialText")
	super.exorcize(offset)
