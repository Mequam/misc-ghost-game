extends Entity

# this script represents an enemy that grows out of the ground
# the current art looks like grape soda :>

class_name GroundHogEnemy

@export var growth_speed : float = 0.01
#the highest we can grow too
@export var max_growth : float = 100.0
#the lowest we can grow to
@export var min_growth : float = 10.0
#if true we set max growth from the current scale of the entity on ready
@export var set_max_growth : bool = true

@export var sprite_bone : Node2D
var height : float :
	set(val):
		height = val
		self.scale.y = val
	get:
		return self.scale.y

func _ready() -> void:
	if self.set_max_growth:
		self.max_growth = self.height


func _process(delta: float) -> void:
	if self.pressed_inputs["UP"] and self.max_growth >= self.height:
		self.height += self.growth_speed
	if self.pressed_inputs["DOWN"] and self.height >= 0:
		self.height -= self.growth_speed

	#collision_shape.shape.size.y = self.height
