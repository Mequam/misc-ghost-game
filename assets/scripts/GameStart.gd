extends BackStack
#this script is called checked the very first node in the very first scene of the game
#it is inteanded to initilize and control UI for that scene 



# Called when the node enters the scene tree for the first time.
func _ready():
	SaveUtils.generate_file_structure()
