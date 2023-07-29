extends FlightEntity
#this class is the generic class for the evil ghosts
#that posses things and get kicked out of possesion other than Leni

class_name EvilGhost

enum EvilGhostState {
	JUST_SPAWNED = Entity.ENTITY_STATE_COUNT
}
#flag used to indicate when we are unchecked of the screen
var offscreen  : bool = false
func ai_move_at_player(player):
	if player.position.x < position.x:
		perform_action("RIGHT",false)
		perform_action("LEFT",true)
	else:
		perform_action("LEFT",false)
		perform_action("RIGHT",true)
func AI(player):
	match state:
		EvilGhostState.JUST_SPAWNED:
			perform_action("UP",true)
		EntityState.DEFAULT:
			if offscreen:
				ai_move_at_player(player)
			if not (pressed_inputs["LEFT"] or pressed_inputs["RIGHT"]):
				ai_move_at_player(player)
			if player.position.y > position.y:
				perform_action("UP",false)
				perform_action("DOWN",true)
			else:
				perform_action("DOWN",false)
				perform_action("UP",true)
	super.AI(player)
#every ghost has a possesion color 
#that the game uses to know when it is possesed
var glow_color : Color = Color(0.5,1,0.58)

#we are NEVER possesed because we are a ghost no :D
func set_possesed(val : bool)->void:
	possesed = false
func main_ready():
	print("ghost main ready")
	speed = 300*Vector2.ONE
	add_to_group("EvilGhost")
	self.possesed = false
	super.main_ready()
	self.state = EvilGhostState.JUST_SPAWNED
							#and enable normal movement as a result
func gen_col_layer():
	return ColMath.Layer.NON_PLAYER_ENTITY
func gen_col_mask():
	return ColMath.Layer.PLAYER
func compute_velocity(vel):
	match state:
		EvilGhostState.JUST_SPAWNED:
			return super.compute_velocity(vel) * 0.5
	
	var ret_val =  super.compute_velocity(vel)
	ret_val.y *= 0.5
	
	return ret_val
func set_state(val : int )->void:
	match val:
		EvilGhostState.JUST_SPAWNED:
			collision_mask = 0
			collision_layer = 0
			$dazed_timer.wait_time = 1
			$dazed_timer.start() #when this finishes we change state to default
	super.set_state(val)
#overshadows the given entity
#NOTE:
#this is much less invasive than Lenis Possesion
#basically this just makes the given entity glow and spawn a ghost when
#it dies
func posses(entity_to_posses)->void:
	pass
func on_dazed_timer_out():
	super.on_dazed_timer_out()
	collision_layer = gen_col_layer()
	collision_mask = gen_col_mask()
	$Sprite2D.play("run")
func on_col(obj):
	if obj.collider is Entity and obj.collider.state != EntityState.DAMAGED:
		obj.collider.take_damage(1)

func _on_VisibilityNotifier2D_screen_exited():
	offscreen = true


func _on_VisibilityNotifier2D_screen_entered():
	offscreen = false
