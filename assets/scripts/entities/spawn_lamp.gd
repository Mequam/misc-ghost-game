extends Npc

class_name RespawnLamp

#we do NOT move
func move_and_collide(rel_vec : Vector2, 
						infinite_inertia : bool = false, 
						exclude_raycast_shapes : bool = true,
						test_only : bool = false)->KinematicCollision2D:
	return null
#returns the name that we use to respawn
func gen_respawn_name()->String:
	return name
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func update_animation():
	$Sprite/AnimationPlayer.play("sway")
func take_damage(amount : int = 1,source = null)->void:
	pass
func die():
	.unposses_position()
func gen_col_layer()->int:
	return ColMath.Layer.TERRAIN
func gen_col_mask()->int:
	return 0
func set_possesed(val : bool)->void:
	if val:
		$Sprite/LampTop.material = possesed_material
	else:
		$Sprite/LampTop.material = null
	.set_possesed(val)
