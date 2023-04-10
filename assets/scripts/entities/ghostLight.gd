extends Entity

func on_action_double_press(action):
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
func exorcize()->void:
	print("FREE LENI!")
	super.exorcize()
#we function on the same layer as a pickup
func gen_col_layer()->int:
	return ColMath.Layer.PICKUP
#we do not collide with anything ourselfs
func gen_col_mask()->int:
	return 0
func posses_by(entity):
	print("ghost light detects posses!")
	super.posses_by(entity)
	collision_mask = gen_col_mask()
	collision_layer = gen_col_layer()
