extends StaticBody2D
#simple collision script that ensures the ground is checked
#the poper layer

class_name Ground




func _ready():
	collision_layer = ColMath.ConstLayer.TILE_BORDER | ColMath.Layer.TERRAIN
	collision_mask = 0
