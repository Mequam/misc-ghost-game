extends Control

class_name Cropper

#this class represents a control node that hides it's children until
#the node is hovered over, basically a crop control
#think for things like tool tips and automatic reveals

@export var do_cropp : bool = true

#if > 0 we want to not crop
var hover_count : int = 0 :
	set (val):
		if val < 0: val = 0
		hover_count = val 
		self.clip_contents = (hover_count == 0) and do_cropp
	get:
		return hover_count
		

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		if c is Control:
			c.mouse_entered.connect(incriment_hover_count)
			c.mouse_exited.connect(decriment_hover_count)

func incriment_hover_count()->void:
	self.hover_count+=1
func decriment_hover_count()->void:
	self.hover_count-=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
