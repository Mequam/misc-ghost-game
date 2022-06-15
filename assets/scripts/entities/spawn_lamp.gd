extends Npc

class_name RespawnLamp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func update_animation():
	$Sprite/AnimationPlayer.play("sway")
func take_damage(amount : int = 1,source = null)->void:
	pass
func die():
	.unposses_position()
func set_possesed(val : bool)->void:
	if val:
		$Sprite/LampTop.material = possesed_material
	else:
		$Sprite/LampTop.material = null
	.set_possesed(val)
