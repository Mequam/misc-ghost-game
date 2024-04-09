extends DialogComponent

#this class represents a state machine selction of dialog,
#like an if statement in the dialog tree


class_name DialogStateMachine

@export var selection : int = 0:
	set(val):
		#undisplay the current child
		if get_child(selection):
			get_child(selection).undisplay()
		selection=val
	get:
		return selection

func _ready()->void:
	for c in get_children():
		if c is DialogComponent:
			c.on_displayed.connect(on_child_displayed)

#tell the world when we get displayed
func on_child_displayed(child):
	self.on_displayed.emit(self)

func undisplay()->void:
	get_child(selection).undisplay()

func displayed()->bool:
	return get_child(selection).displayed()

func display()->void:
	get_child(selection).display()

func next()->void:
	get_child(selection).next()
