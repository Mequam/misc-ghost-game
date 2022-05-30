extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var backwords : bool = false
func _on_elevatorSprite_animation_finished():
	match animation:
		"open":
			if not backwords:
				backwords = true
				play("open",true)
			else:
				backwords = false
				stop()
				frame = 0
