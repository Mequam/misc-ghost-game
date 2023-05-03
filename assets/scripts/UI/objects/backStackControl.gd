extends BackStack 

#this class extends the functionality of a back stack to include back button
#behavior automatically

class_name BackStackControl


@export var back_button : TextureButton
@export var container : Control

#ensures that the visibility of the back button makes sense
func update_visibility()->void:
	container.visible = len(stack) != 0

func back()->void:
	super.back()
	update_visibility()


func next(target : Control, r : Control = self.replacement)->void:
	super.next(target,r)
	update_visibility()

# Called when the node enters the scene tree for the first time.
func _ready():
	update_visibility()
	back_button.pressed.connect(on_back_button_pressed)

func on_back_button_pressed()->void:
	print("the back button was pressed!")
	back()
