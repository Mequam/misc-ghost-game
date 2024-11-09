extends AnimatedSprite2D


func custom_play(anim)->void:
	self.play(anim)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.material.set_shader_parameter("scale",self.global_scale.y)
