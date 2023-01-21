extends FlightEntity
#this class represents an entity that can fly
#but gets tired and falls if flying too long


class_name TiredFlightEntity

#we can only fly for so long before we get tired
var tired : bool = false :
	get:
		return tired # TODOConverter40 Copy here content of get_tired
	set(mod_value):
		tired = mod_value
		update_animation()

func get_tired()->bool:
	return tired

func main_ready():
	$flight_timer.connect("timeout",Callable(self,"_on_flight_timer_timeout"))
	super.main_ready()

func set_ground_counter(val : int)->void:
	var old_on_ground = self.onground
	super.set_ground_counter(val)
	if not old_on_ground and self.onground:
		tired = false
		$flight_timer.stop()
	if not self.onground:
		$flight_timer.start()
	update_animation()

func compute_velocity(vel : Vector2)->Vector2:
	if not possesed:
		return Vector2(0,0)
	match state:
		EntityState.DEFAULT:
			if tired:
				vel.y += 1.2
			return super.compute_velocity(vel)
	return super.compute_velocity(vel)	

func _on_flight_timer_timeout():
	self.tired = true
