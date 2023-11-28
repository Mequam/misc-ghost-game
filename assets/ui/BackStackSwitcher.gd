extends Node

#this is a convinence class that offers the capabilities
#implement switching too and from the back stack
#in a general purpose node to be exported to other controls
#this feature also exists in a purly control form as a button,
#this implementation is a bit more desireable as it is easy
#to rapidly add to other controls

class_name BackStackSwitcher

#the next scene we want to open
@export var next : PackedScene
#the control node whose child we want to replace
@export var replace_container : Control

#refernece to the back stack that the node uses, if not set
#the node will climb the tree on ready to locate the back stack
@export var back_stack : BackStack = null

#returns the back stack that we are parented too
func get_back_stack_parent()->BackStack:
	var next = get_parent().get_parent()
	while not (next is BackStack):
		next = next.get_parent()
	return next

func on_parent_pressed()->void:
	back_stack.next((self.next.instantiate()),self.replace_container)
	
func _ready()->void:
	#ensure we have a reference to the back stack
	if back_stack == null:
		back_stack = self.get_back_stack_parent()

	get_parent().pressed.connect(self.on_parent_pressed)


