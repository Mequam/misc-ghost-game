extends DialogComponent

#this class is a dialog that is ENTIRELY
#created from children dialogs
#the idea is that you chain them together,

#revealing this dialog simply reveals the first child

class_name DialogContainer


#we are displayed ONLY if ALL children are displayed
func displayed()->bool:
	if not self.visible: return false

	for child in get_children():
		if child is DialogBubble and not child.displayed():
			return false
	return true

#convinence function to display ALL children of our dialog
func display_all()->void:
	while not self.displayed():
		self.display()

#hide all children if asked to undisplay
func undisplay()->void:
	for child in get_children():
		if child is DialogComponent:
			child.undisplay()

#when we are displayed we display only the first undisplayed child
func display()->void:
	#store if we are displayed enough for the rising edge
	var displayed = self.displayed()

	self.visible = true

	for node in get_children():
		if node is DialogComponent and not node.displayed():
			node.display()
			break

	#detect the rising edge of display
	if not displayed and self.displayed():
		on_displayed.emit(self)

