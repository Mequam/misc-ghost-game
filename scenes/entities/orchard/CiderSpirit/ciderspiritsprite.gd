extends CustomAnimationChain
#this is the custom animation script for the cider sprite

@export var transform_animator : AnimationPlayer
func _ready():
	transform_animator.animation_finished.connect(on_transform_anim_finished)
	animation_finished.connect(on_anim_finished)

func on_anim_finished():
	match animation:
		"launch":
			custom_play("fly")
		"launch_down":
			tail = ""
			custom_play("fly")

func on_transform_anim_finished(anim)->void:
	match anim:
		"walk_right":
			custom_play("idle")
var tail : String = ""
func custom_play(anim_name : StringName = "idle", backwoards : bool = false)->void:
	match anim_name:
		"walk_right":
			stop()
			transform_animator.play("walk_right")
		"splash":
			#play the sound
			if self.animation != "splash":
				$splash.play()
			transform_animator.stop()
			transform_animator.play("RESET")
		_:
			transform_animator.stop()
			transform_animator.play("RESET")
	super.custom_play(anim_name+tail,backwoards)
