extends Control

#this class represents a single component of dialog that can be chosen from
#think dialog bubbles, choices are sets of bubbles

class_name DialogComponent


signal on_displayed

#represents the next dialog component to run
@export var next_component : DialogComponent

#the function that we use to get the next component of dialog
func get_next_component()->Node:
	if next_component != null: return next_component
	return get_child(1)

#called to display this section of dialog
func display()->void:
	on_displayed.emit(self)

#indicator if we are displayed to the player
func displayed()->bool:
	return self.visible

#performs any actions necessary to hide the component
func undisplay()->void:
	self.visible = false

#show the next component in the chain, can be
#called from ANY bubble in the chain and still
#allow the next to show
func next()->void:
	if not self.displayed():
		#show the bubble
		display()
	elif get_next_component():
		get_next_component().next()

