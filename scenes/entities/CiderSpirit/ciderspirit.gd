extends LRJEntity

class_name CiderSpirit


@export var hop_distance : float = 10
@export var transform_animation : AnimationPlayer


func on_transform_animation_finished(anim):
	if anim == "walk_right":
		hop()

func main_ready()->void:
	transform_animation.animation_finished.connect(self.on_transform_animation_finished)
	super.main_ready()
var hop_dir : String = ""
func hop()->void:
	match hop_dir:
		"LEFT":
			singal_move_and_collide(Vector2(-hop_distance,0))
		"RIGHT":
			singal_move_and_collide(Vector2(hop_distance,0))
			
func on_action_press(action : String)->void:
	if action == "LEFT" or action == "RIGHT":
		hop_dir = action 
	
