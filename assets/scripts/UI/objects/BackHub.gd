extends Control

#this class impliments back behavior using a stack

class_name BackStack

@export var replacement : Control

var stack = []

#replaces the current target replace nodes child with the given child
func replace(c : Control, r : Control = replacement)->void:
	r.remove_child(r.get_child(0))
	r.add_child(c)

#loads the next scene and prepares the stack for back
#behavior
func next(next_control : Control,replace : Control = replacement)->void:
	stack.append([replace.get_child(0),replace])
	replace(next_control,replace)

#continually pops from the stack until there are no
#controls left
func purge_stack()->void:
	while len(stack) != 0:
		self.back()
#moves back to the last scene in the stack
func back()->void:
	var to_replace = stack.pop_back()
	if to_replace != null:
		replace(to_replace[0],to_replace[1])
