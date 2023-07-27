extends CustomAnimationChain
#this is the custom animation script for the cider sprite

@export var transform_animator : AnimationPlayer
func _ready():
	transform_animator.animation_finished.connect(on_transform_anim_finished)
func on_transform_anim_finished(anim)->void:
	match anim:
		"walk_right":
			custom_play("idle")
func custom_play(anim_name : StringName = "idle", backwoards : bool = false)->void:
	match anim_name:
		"walk_right":
			stop()
			transform_animator.play("walk_right")
		_:
			transform_animator.stop()
			transform_animator.play("RESET")
	super.custom_play(anim_name,backwoards)
