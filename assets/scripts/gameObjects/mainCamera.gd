extends Camera2D

#simple script that gets the Camera2D to
#follow a given target

@export 
var target : Node2D = null

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position = position.lerp(target.position,0.5)
