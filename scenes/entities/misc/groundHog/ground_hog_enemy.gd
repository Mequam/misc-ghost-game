extends Entity

# this script represents an enemy that grows out of the ground
# the current art looks like grape soda :>

class_name GroundHogEnemy

@export var growth_speed : float = 0.01

@export var sprite_bone : Node2D
var height : float :
	set(val):
		height = val
		self.sprite_bone.scale.y = val
	get:
		return self.sprite_bone.scale.y

func _process(delta: float) -> void:
	if self.pressed_inputs["UP"]:
		self.height += self.growth_speed
	if self.pressed_inputs["DOWN"]:
		self.height -= self.growth_speed
