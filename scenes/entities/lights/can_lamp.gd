extends CanLamp

func posses_by(entity)->void:
	super.posses_by(entity)
	$DisapearingLabel/AnimationPlayer.play("TutorialText")
func exorcize(offset : Vector2 = Vector2(0,0),eject : bool = false)->void:
	super.exorcize(offset,eject)
	$DisapearingLabel/AnimationPlayer.play_backwards("TutorialText")
