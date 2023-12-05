extends Entity

#this class represents an entity that does NOT move
#and does NOT take damage, its really dumb

class_name DumbyEntity

var original_unpos_spot : Vector2

#the ghost lamp saves when possesed
func posses_by(entity):
	super.posses_by(entity)
	collision_mask = gen_col_mask()
	collision_layer = gen_col_layer()

#we function on the same layer as a pickup
func gen_col_layer()->int:
	return ColMath.Layer.PICKUP
#we do not collide with anything ourselfs
func gen_col_mask()->int:
	return 0

func handle_action(action)->void:
	match action:
		"LEFT":  
			$unposSpot.position = Vector2(-1,0) * self.unposses_radius + self.original_unpos_spot
		"RIGHT":  
			$unposSpot.position = Vector2(1,0 ) * self.unposses_radius + self.original_unpos_spot
		"DOWN":  
			$unposSpot.position = Vector2(0,1 ) * self.unposses_radius + self.original_unpos_spot
		"UP":  
			$unposSpot.position = Vector2(0,-1) * self.unposses_radius + self.original_unpos_spot
	exorcize()

func on_action_double_press(action):
	handle_action(action)
func on_action_press(action):
	handle_action(action)
func _ready()->void:
	self.original_unpos_spot = $unposSpot.position
	super._ready()
