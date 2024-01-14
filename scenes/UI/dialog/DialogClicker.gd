extends DialogComponent

#simple class that hops to the next dialog on player click

class_name DialogClicker

@export var enabled : bool = true

func _input(event : InputEvent)->void:
	if Input.is_action_just_pressed("INTERACT"):
		if self.enabled:
			self.next()


#we don't hide ourselfs, we just hide our child
func undisplay()->void:
	if self.get_next_component():
		self.get_next_component().undisplay()
