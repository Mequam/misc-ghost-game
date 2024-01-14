extends DialogComponent

#this class cyclically displays dialog until triggered to move
#onto the next dialog component

#note: this node expects ALL children node to be dialog components
#no checking is done to account for this fact

class_name DialogHopper

#if true we loop to the start when finished with our dialog sequence
@export var loop : bool = true
@export var hide_previous : bool = true
@export var hide_children : bool = true

#the current dialog element that we are looking at
#when this hits the last element then we are done
var idx : int = 0

func displayed()->bool:
	return not self.loop and self.idx >= self.get_child_count()-1

func check_displayed()->void:
	if self.displayed():
		on_displayed.emit(self)
	
	if not self.loop:
		return

	#actually do the looping
	idx = 0
	self.display()
	return




func get_selected_component()->Control:
	if idx >= get_child_count(): 
			return get_child(get_child_count()-1)
	return get_child(idx)


func get_next_component()->Control:
	if idx >= get_child_count()-1:
		if not self.loop:
			return get_selected_component()
		return get_child(0)
	return get_child(idx+1)


func increment_selection()->void:
	if self.hide_previous:
		get_selected_component().undisplay()
	get_next_component().display()
	
	self.check_displayed()
	
	if not self.loop and idx == get_child_count()-1:
		return
	
	idx += 1
	idx %= get_child_count()

func display()->void:
	if self.displayed():
		return
	#if the currently selected component is not displayed, display it
	if get_selected_component() and not get_selected_component().displayed():
		get_selected_component().display()
		return
	super.display()
	
	#theres no need to incriment if we are looped
	if not self.loop and idx == get_child_count()-1:
		return

	#move onto the next object
	increment_selection()

func undisplay()->void:
	#hide the current index
	if hide_children:
		get_selected_component().undisplay()
	else:
		super.undisplay()


