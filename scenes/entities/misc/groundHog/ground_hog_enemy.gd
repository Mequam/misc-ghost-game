extends Entity


class_name GroundHogEnemy

@export var sprite_bone : Node2D
var height : float :
	set(val):
		height = val
		self.sprite_bone.scale.y = val
	get:
		return self.sprite_bone.scale.y

func _process(delta: float) -> void:
	if self.pressed_inputs["UP"]:
		self.height += 0.01
	if self.pressed_inputs["DOWN"]:
		self.height -= 0.01
