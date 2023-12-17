extends TiredFlightEntity

#this class represents a bat that can expload
#when you press the interact button

class_name BatSplosion

enum BatSplosionState {
	HANGING, #we hang from the ceiling and do not move save for unhanging
	EXPLOADING #we are activly exploading
	
}


func expload()->void:
	#enable the explosion animation

	self.state = BatSplosionState.EXPLOADING
	self.get_sprite2D().custom_play("expload")

func on_action_press(act : String)->void:
	match act:
		"ATTACK":
			self.expload()
func main_ready()->void:
	super.main_ready()
	self.update_animation()

