extends EntityAI 
#this AI runs to pick apples, 
#and then walks to the player to shoot them

class_name AIApplePickerFindShoot

var ai_apple_target = null 
@export var aggro_threshold = 600
@export var shoot_threshold = 300
@export var navigation_resource : SubAINavigationStraight

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

func setup(caller : Entity)->void:
	super.setup(caller)
	caller.sig_on_col.connect(ai_on_col)
	navigation_resource.setup(caller)


#called when we have apples
func aggro(player : Entity)->void:
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

		self.navigation_resource.set_target(player.global_position)
		self.navigation_resource.tick(player)

var is_aggro : bool = false

func tick(player : Entity)->void:
	can_see_player(player)
	if caller.apple_count > 0:
		if player.global_position.distance_squared_to(caller.global_position) < 600:
			pass
		aggro(player)
	else:
		if ai_apple_target == null:
			self.ai_apple_target = self.ai_get_apple_target()
			self.navigation_resource.set_target(self.ai_apple_target.global_position)
		else:
			if caller.global_position.distance_squared_to(self.ai_apple_target.global_position) < 100**2:
				#if we are within range, attack the target to harvest it 
				caller.perform_action( "ATTACK",true )
				self.ai_apple_target = null
			else:
				navigation_resource.tick(player)
