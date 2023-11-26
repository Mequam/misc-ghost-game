extends EntityAI 
#this AI runs to pick apples, 
#and then walks to the player to shoot them

class_name AIApplePickerFindShoot

var ai_apple_target = null 
@export var shoot_threshold = 300

func get_danger_level()->int:
	if caller.apple_count == 0:
		return 0
	return self.get_danger_level()
func ai_on_col(col)->void:
	var norm = col.get_normal()
	if norm.x > norm.y*2:
		caller.perform_action("UP",true)
#returns a pickable apple that we can target to re-fill
func ai_get_apple_target()->PickableApple:
	var nodes = caller.get_tree().get_nodes_in_group("pickable_apples")
	var best : float = 99999**2
	var best_node : PickableApple = null
	for apple in nodes:
		if apple.is_harvestable():
			var dist = apple.global_position.distance_squared_to(caller.global_position)
			if dist < best:
				best = dist 
				best_node = apple
	return best_node 

func tick(player : Entity)->void:
	#stop flying up if we are going in the up direction
	if caller.pressed_inputs["UP"]:
		caller.perform_action("UP",false)
	if caller.apple_count > 0:
		var distance_squared_to_player = caller.global_position.distance_squared_to(player.global_position)
		if  distance_squared_to_player < self.shoot_threshold**2 and not caller.pressed_inputs["ATTACK"]:
			#shoot the apples at the player
			#remove the left and right inputs
			caller.clear_stored_inputs()
			caller.perform_action("ATTACK",true)
		elif distance_squared_to_player > shoot_threshold**2:
			if caller.pressed_inputs["ATTACK"]:
				caller.perform_action("ATTACK",false)
				await caller.get_tree().process_frame

			if player.global_position.x < caller.global_position.x and not caller.pressed_inputs["LEFT"]:
				caller.perform_action("RIGHT",false)
				caller.perform_action("LEFT",true)
			elif player.global_position.x > caller.global_position.x and not caller.pressed_inputs["RIGHT"]:
				caller.perform_action("LEFT",false)
				caller.perform_action("RIGHT",true)
	else:
		if ai_apple_target == null:
			self.ai_apple_target = self.ai_get_apple_target()
		else:
			#if we are within range, attack the target to harvest it 
			if caller.global_position.distance_squared_to(self.ai_apple_target.global_position) < 100**2:
				caller.perform_action( "ATTACK",true )
				self.ai_apple_target = null
			else:
				#it is above us, move up (it has to be above or bellow since our x is aligned but we are not colliding)
				if abs(caller.global_position.x - self.ai_apple_target.global_position.x) < 50:
					caller.perform_action("RIGHT",false)
					caller.perform_action("LEFT",false)
					caller.perform_action("UP",true)
				else:
					if self.ai_apple_target.global_position.x < caller.global_position.x and not caller.pressed_inputs["LEFT"]:
						caller.perform_action("RIGHT",false)
						caller.perform_action("LEFT",true,true)
					elif self.ai_apple_target.global_position.x > caller.global_position.x and not caller.pressed_inputs["RIGHT"]:
						caller.perform_action("LEFT",false)
						caller.perform_action("RIGHT",true,true)

	pass
