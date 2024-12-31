extends Entity

# this script represents an enemy that grows out of the ground
# the current art looks like grape soda :>

class_name GroundHogEnemy

@export var growth_speed : float = 0.01
@export var max_growth : float = 100.0

#collision shape referenec we change with our height
@export var collision_shape : CollisionShape2D

@export var sprite_bone : Node2D
var height : float :
	set(val):
		height = val
		self.scale.y = val
	get:
		return self.scale.y

func _process(delta: float) -> void:
	if self.pressed_inputs["UP"] and self.max_growth >= self.height:
		self.height += self.growth_speed
	if self.pressed_inputs["DOWN"] and self.height >= 0:
		self.height -= self.growth_speed

	#collision_shape.shape.size.y = self.height
