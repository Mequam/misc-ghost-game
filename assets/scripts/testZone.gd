extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_SPACE:
			$Leni.posses($possesed_elevator)


# Called every frame. 'delta' is the elapsed time since the previous frame.
