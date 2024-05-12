extends Projectile

class_name WitchProjectile

#reference to the witch that shot us
#used to enable the teleport
var witch = null

# Called when the node enters the scene tree for the first time.
@export var magic : PackedScene 
func main_ready():
	var inst = magic.instantiate()
	inst.global_position = global_position
	get_parent().add_child(inst)
	speed = 100*Vector2.ONE
	$AnimationPlayer.play("scale_up")
	$witchProjSprite.play("default")
	
	#make sure that the previous class gets to run its ready function
	super.main_ready()
func die():
	var inst = magic.instantiate()
	get_parent().add_child(inst)
	inst.global_position = global_position
	super.die()

func on_col(collider):
	var entity = collider.get_collider()
	
	#we can teleport entities and players, that is IT
	if not entity is TileMap and entity.collision_layer & (ColMath.Layer.NON_PLAYER_ENTITY | ColMath.Layer.PLAYER) != 0: 
		#swap the position of us and the entitiy on collision
		var old_pos : Vector2 = witch.global_position 
		witch.global_position = entity.global_position 
		entity.global_position = old_pos 
		
		#play the bwingwing teleport noise
		if witch != null and witch.bwingwing != null:
			witch.bwingwing.play()
	super.on_col(collider)
