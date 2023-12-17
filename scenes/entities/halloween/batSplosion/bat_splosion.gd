extends TiredFlightEntity

#this class represents a bat that can expload
#when you press the interact button

class_name BatSplosion


enum BatSplosionState {
	HANGING #we hang from the ceiling and do not move save for unhanging
}


func unexpload()->void:
	self.get_sprite2D().custom_play("unexpload")
func expload()->void:
	#enable the explosion animation
	self.get_sprite2D().custom_play("expload")
func on_action_press(act : String)->void:
	match act:
		"ATTACK":
			self.expload()
func on_action_released(act : String)->void:
	match act:
		"ATTACK":
			self.unexpload()

func get_exploasion_speed_modifier()->float:
	var anim = get_sprite2D().animation
	if anim == "expload":
		return 5*get_sprite2D().frame+1
	return 1

func compute_velocity(vel : Vector2)->Vector2:
	if self.get_sprite2D().animation == "no_return":
		return Vector2(0,0)
	return super.compute_velocity(vel)/self.get_exploasion_speed_modifier()

func main_ready()->void:
	super.main_ready()
	self.get_sprite2D().play("idle")
	self.get_sprite2D().animation_finished.connect(on_anim_finished)

var dying : bool = false
func on_anim_finished():
	#if we ever get to the point where we expload, we DIE
	match self.get_sprite2D().animation:
		"no_return":
			if self.dying:
				#really launch the player
				$unposSpot.position *= 2
				self.die()
			self.dying = true
