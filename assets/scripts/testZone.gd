extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_P:
		$witch/Sprite.play("up")
