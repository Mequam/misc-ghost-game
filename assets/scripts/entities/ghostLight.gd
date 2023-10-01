extends Entity

class_name RespawnLamp

func handle_action(action)->void:
	match action:
		"LEFT":
			$unposSpot.position = Vector2(-150,0)+Vector2(0,100)

		"RIGHT":
			$unposSpot.position = Vector2(150,0)+Vector2(0,100)
		"DOWN":
			$unposSpot.position = Vector2(0,150)+Vector2(0,100)
		"UP":
			$unposSpot.position = Vector2(0,-150)+Vector2(0,100)
	exorcize()

func on_action_double_press(action):
	handle_action(action)
func on_action_press(action):
	handle_action(action)

#we function on the same layer as a pickup
func gen_col_layer()->int:
	return ColMath.Layer.PICKUP
#we do not collide with anything ourselfs
func gen_col_mask()->int:
	return 0


#gets the load path from the parent of the respawn lamp
func get_level_path()->String:
	return self.get_parent().load_path

#the ghost lamp saves when possesed
func posses_by(entity):
	#TODO:
	GameLoader.save_game_from_lamp(self)
	super.posses_by(entity)
	collision_mask = gen_col_mask()
	collision_layer = gen_col_layer()
