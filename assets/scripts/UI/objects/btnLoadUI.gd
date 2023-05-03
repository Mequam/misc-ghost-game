extends TextureButton 

#this is a convinence script that creates a button that loads the given UI into
#the given node

class_name btnLoadUI

#where we are going to load to
@export var destination : Control
#the scene that we want to load
@export var target : PackedScene
#backstack node that we use to keep track of changes
@export var backstack : BackStack


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(on_self_pressed)

func on_self_pressed()->void:
	#load the next scene
	backstack.next(target.instantiate(),destination)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
