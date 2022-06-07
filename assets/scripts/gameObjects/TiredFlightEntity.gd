extends FlightEntity
#this class represents an entity that can fly
#but gets tired and falls if flying too long


class_name TiredFlightEntity

#we can only fly for so long before we get tired
var tired : bool = false setget set_tired,get_tired
func set_tired(val : bool)->void:
	tired = val
	update_animation()
func get_tired()->bool:
	return tired

func main_ready():
	$flight_timer.connect("timeout",self,"_on_flight_timer_timeout")
	.main_ready()

func set_onground(val : bool)->void:
	if not onground and val:
		tired = false
		$flight_timer.stop()
	if not val:
		$flight_timer.start()
	update_animation()
	.set_onground(val)

func compute_velocity(vel : Vector2)->Vector2:
	if not possesed:
		return Vector2(0,0)
	match state:
		EntityState.DEFAULT:
			if tired:
				vel.y += 1.2
			return .compute_velocity(vel)
	return .compute_velocity(vel)	

func _on_flight_timer_timeout():
	self.tired = true
