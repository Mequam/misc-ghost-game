extends LRJEntity

#this file is the witch entity

class_name Witch

@export var collumn : PackedScene
@export var witchProjectile : PackedScene

@export var bwingwing : AudioStreamPlayer2D

#represents the number of times that we can shoot in the air
@export var air_shoots : int = 1
var air_shoots_current : int = 1
var can_shoot : bool = true

@export var projectile_launch_speed : float = 100

func get_entity_type()->String:
	return "Witch"

func on_ground_changed(val : int)->void:
	super.on_ground_changed(val)
	air_shoots_current = air_shoots

func collumn_attack()->void:
	$Sprite2D.custom_play("attack")
	state = EntityState.BRICK
	if ($Sprite2D.flip_h and $col_spawn_position.position.x > 0) or (not $Sprite2D.flip_h and $col_spawn_position.position.x < 0):
		$col_spawn_position.position.x *= -1
	spawn_object(collumn,$col_spawn_position.global_position + Vector2(0,50))
func get_projectile_launch_velocity()->Vector2:
	if not self.onground:
		var ret_val = Vector2(1,0.5)
		if get_sprite2D().flip_h: ret_val.x = -1
		if self.velocity.y < 0: ret_val.y = -0.5
		return ret_val.normalized()*projectile_launch_speed
	
	return Vector2(1-2*int(get_sprite2D().flip_h),0)*projectile_launch_speed


#fires the witch projectile using our velocity as direction
func shoot_witch_projectile()->void:
	if not can_shoot or not self.onground and air_shoots_current <= 0: return
	
	if ($Sprite2D.flip_h and $col_spawn_position.position.x > 0) or (not $Sprite2D.flip_h and $col_spawn_position.position.x < 0):
		$col_spawn_position.position.x *= -1

	var proj = shoot(witchProjectile,$col_spawn_position.global_position,get_projectile_launch_velocity())

	#since the projectile has knowledge about collision, they call back to us when colliding
	#so that we can teleport swap and perform any other action that we need to do
	proj.witch = self
	proj.tree_exited.connect(
		func():
			can_shoot = true
)

	$Sprite2D.custom_play("attack")
	state = EntityState.BRICK
	$shoot_sound.play()

	can_shoot = false
	if not self.onground: air_shoots_current -= 1

func on_action_press(act : String)->void:
	match act:
		"ATTACK":
			if self.pressed_inputs["UP"]:
				collumn_attack()
			else:
				shoot_witch_projectile()
	super.on_action_press(act)

func update_animation(event : InputEvent = null)->void:
	if state != EntityState.BRICK and state != EntityState.DAMAGED:
		super.update_animation()

func _on_Sprite_animation_finished():
	if $Sprite2D.animation == "attack":
		if state != EntityState.DAMAGED:
			state = EntityState.DEFAULT
			update_animation()
