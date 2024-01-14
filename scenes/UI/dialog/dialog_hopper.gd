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
var next_idx : int = 0

func displayed()->bool:
	return super.displayed() and not self.loop and self.next_idx >= self.get_child_count()

func check_displayed()->void:
	if not self.loop: 
		on_displayed.emit(self)
		return 
	
	#actually do the looping
	next_idx = 0
	self.display()
	return




func get_selected_component()->Control:
	if next_idx - 1 >= 0: return get_child(next_idx -1)
	return get_child(get_child_count()-1)
func get_next_component()->Control:
	return get_child(next_idx)


func increment_selection()->void:
	if self.hide_previous:
		get_selected_component().undisplay()
	get_next_component().display()
	next_idx += 1
	next_idx %= get_child_count()

func display()->void:
	#if the currently selected component is not displayed, display it
	if get_selected_component() and not get_selected_component().displayed():
		print_debug("displaying the currently selected component")
		get_selected_component().display()
		return

	super.display()
	if next_idx >= get_child_count():
		print_debug("no next component!")
		#recuuuursion babyeeeeee
		check_displayed()
		return
	#move onto the next object
	increment_selection()

func undisplay()->void:
	#hide the current index
	if hide_children:
		get_selected_component().undisplay()
	else:
		super.undisplay()


