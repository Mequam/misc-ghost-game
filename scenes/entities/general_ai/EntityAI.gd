extends Resource

class_name EntityAI 

#convinence function to match the perform action in the entity class
#see entity.gd
func perform_action(act : String,
pressed : bool,
double_press : bool = false,
echo : bool = false)->void:
	print("ENTITY AI CALLING")
	caller.perform_action(act,pressed,double_press,echo)
#convinence reference to the parent that is using us, we could
#make this a node, but the convinence of recourses for AI makes it easaier
#to develop in the editor, plus its minimal concideration for performance either way
var caller : Entity = null

#this function is called when the ai wants to run
#with the player location
#see entity.gd
func tick(_player_location : Entity)->void:
	pass 

#called in the entity to initilize this AI,
#again see entity.gd / _ready
func setup(caller : Entity)->void:
	self.caller = caller
