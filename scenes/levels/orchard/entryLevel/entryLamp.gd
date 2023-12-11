extends RespawnLamp

func posses_by(entity):
	$DisapearingLabel/AnimationPlayer.play("TutorialText")
	super.posses_by(entity)

func exorcize(offset : Vector2 = Vector2(0,0))->void:
	$DisapearingLabel/AnimationPlayer.play_backwards("TutorialText")
	super.exorcize(offset)
