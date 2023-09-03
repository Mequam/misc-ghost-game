extends Node2D


func custom_play(animation : StringName  = "idle",backwards : bool = false)->void:
	match animation:
		"roll":
			$AnimationPlayer.play("roll_prep")
		_:
			$AnimationPlayer.play(animation)
