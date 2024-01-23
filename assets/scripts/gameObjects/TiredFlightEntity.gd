extends FlightEntity
#this class represents an entity that can fly
#but gets tired and falls if flying too long


class_name TiredFlightEntity

#we can only fly for so long before we get tired
var tired : bool = true : set = set_tired, get=get_tired
func get_tired():
		return tired
func set_tired(mod_value):
		tired = mod_value
		update_animation()
func main_ready():
	$flight_timer.connect("timeout",Callable(self,"_on_flight_timer_timeout"))
	super.main_ready()
#make it so we are not tired, basically
#reset the timer on bieng tired
func un_tired()->void:
	self.tired=false 
	#ensure we still watch if they can fly
	$flight_timer.stop()
	$flight_timer.start()

func on_ground_changed(val : int)->void:
	super.on_ground_changed(val)
	#not old_on_ground
	if self.onground:
		tired = false
		$flight_timer.stop()
	if not self.onground:
		$flight_timer.start()
	update_animation()

func compute_velocity(vel : Vector2)->Vector2:
	match state:
		EntityState.DEFAULT:
			if tired:
				vel.y += 1.2
			return super.compute_velocity(vel)
	return super.compute_velocity(vel)	

func _on_flight_timer_timeout():
	self.tired = true
