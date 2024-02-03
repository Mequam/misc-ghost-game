extends MainCamera



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	super._process(delta)

func _input(event : InputEvent)->void:
	if event is InputEventKey:
		if event.keycode  == KEY_SPACE and event.pressed:
			print_debug("you pressed me 0_0")
