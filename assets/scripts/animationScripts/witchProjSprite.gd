extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("hello from animated sprite2d!")

func _on_animation_finished():
	match animation:
		"default":
			play("spin")
