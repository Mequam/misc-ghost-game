extends EntityAI

class_name AIBatSplosion

@export var start_hung : bool


func ai_hang()->void:
	print_debug("attempting ai hang")
	perform_action("JUMP",true)


func setup(caller)->void:
	super.setup(caller)
	#attempt to start hanging updside down if we need to start hanging
	if self.start_hung:
		ai_hang()

func tick(player : Entity)->void:
	ai_hang()
