extends AnimatedSprite2D

@export var animation_player : AnimationPlayer

func custom_play(anim)->void:
	self.animation_player.play(anim)

func _ready() -> void:
	self.custom_play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.material.set_shader_parameter("scale",self.global_scale.y/5)
