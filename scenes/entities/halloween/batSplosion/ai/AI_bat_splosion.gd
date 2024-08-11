extends EntityAI

class_name AIBatSplosion

#should we hang from the cieling?
@export var start_hung : bool

#we CAN notice you in this range
@export var aggro_distance : float = 300
#if you are in this speed limit we notice you
@export var speed_limit : float = 1.5
#if you get this close we WILL notice you
@export var will_aggro_distance : float = 100
#how close to you do we need to be to go boom?
@export var explosion_distance : float = 200
#how far away do you need to go to un aggro us?
@export var de_aggro_distance : float = 400
#when we get this close to the player we stop chasing them
@export var chase_threshold : float = 100

func ai_hang()->void:
	perform_action("JUMP",true)
func ai_look_at_player(p)->void:
	#ensure that no other keys are pressed
	perform_action("RIGHT",false)
	perform_action("LEFT",false)


	#move in the appropriate direction to follow the player
	if p.global_position.x > caller.global_position.x:
		perform_action("RIGHT",true)
		perform_action("RIGHT",false)
	else:
		perform_action("LEFT",true)
		perform_action("LEFT",false)

func ai_sprint_at_player(p)->void:
	ai_look_at_player(p)
	if p.global_position.x > caller.global_position.x:
		perform_action("RIGHT",true,true)
	else:
		perform_action("LEFT",true,true)

var aggro : bool = false

func test_for_aggro(player : Entity)->bool:
	#basically, we attack the player if they are too fast in the given range
	#OR they get too close to us

	return (
			player.global_position.distance_squared_to(caller.global_position) \
					< aggro_distance*aggro_distance  \
				and \
			player.compute_velocity(player.velocity).length_squared() \
					>  self.speed_limit * self.speed_limit
				) or player.global_position.distance_squared_to(caller.global_position)  \
						< self.will_aggro_distance * self.will_aggro_distance
func test_for_exploasion(player : Entity)->bool:
	return self.aggro and player.global_position.distance_squared_to(caller.global_position) \
			< self.explosion_distance*self.explosion_distance

func tick(player : Entity)->void:
	if self.start_hung:
		ai_hang()
		self.start_hung = false

	if self.test_for_aggro(player):
		self.aggro = true

	if self.aggro:
		if caller.global_position.distance_squared_to(player.global_position) > self.chase_threshold*self.chase_threshold:
			self.ai_sprint_at_player(player)
		else:
			self.release_input_array(["LEFT","RIGHT"])

		if self.test_for_exploasion(player) and not caller.pressed_inputs["ATTACK"]:
			perform_action("ATTACK",true)

