extends AnimatedSprite

func play(anim="default",reversed = false):
	visible = true
	.play(anim,reversed)
#make it a one shot
func _on_woosh_animation_finished():
	stop()
	visible = false
