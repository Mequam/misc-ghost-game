extends DialogContainer

#this class is a dialog container
#that displays all of it's children in a linear
#order as determined by a timer

class_name LinearDialogContainer


func _ready()->void:
	for child in self.get_children():
		if child is DialogComponent:
			child.on_displayed.connect(self.on_child_displayed)

func on_child_displayed(child):
	self.display()
		


