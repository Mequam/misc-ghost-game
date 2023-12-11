extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(on_body_entered)
	self.body_exited.connect(on_body_exited)
func on_body_entered(body)->void:
	print_debug("showing text!")
	$DisapearingLabel/AnimationPlayer.play("TutorialText")

func on_body_exited(body)->void:
	print_debug("hiding text")
	$DisapearingLabel/AnimationPlayer.play_backwards("TutorialText")
