extends AnimatedSprite2D


func _on_animation_finished():
	match animation:
		"default":
			play("spin")
