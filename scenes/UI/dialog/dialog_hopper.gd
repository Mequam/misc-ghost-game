extends DialogComponent

#this class cyclically displays dialog until triggered to move
#onto the next dialog component

#note: this node expects ALL children node to be dialog components
#no checking is done to account for this fact

class_name DialogHopper

#if true we loop to the start when finished with our dialog sequence
@export var loop : bool = true

#the current dialog element that we are looking at
#when this hits the last element then we are done
var next_idx : int = 0


func displayed()->bool:
	print_debug(super.displayed() and not self.loop and self.next_idx >= self.get_child_count())
	return super.displayed() and not self.loop and self.next_idx >= self.get_child_count()

func check_displayed()->void:
	if not self.loop: 
		on_displayed.emit(self)
		return 
	
	#actually do the looping
	next_idx = 0
	self.display()
	return


func display()->void:
	print_debug(next_idx)

	if next_idx >= get_child_count():
		print_debug("no next component!")
		#recuuuursion babyeeeeee
		check_displayed()
		return
	
	#undisplay the current index
	var next_component = get_child(next_idx)

	
	print_debug(next_component.name)
	#hide the previous if applicable
	if next_idx - 1 >= 0:
		get_child(next_idx - 1).undisplay()
	else:
		#loop around again if we are negative
		var node = get_child(get_child_count()-1)
		print_debug(node.name)
		get_child(get_child_count()-1).undisplay()

	
	next_component.display()
	next_idx += 1
	next_idx %= get_child_count() #loop back around


