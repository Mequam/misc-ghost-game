extends LRJEntity

#this file is the witch entity

class_name Witch

@export var collumn : PackedScene
@export var witchProjectile : PackedScene



#func singal_move_and_collide(rel_vec : Vector2, 
#						test_only : bool = false, 
#						safe_margin : float = 0.8,
#						recovery_as_collision : bool = false)->KinematicCollision2D:
#	var col = super.singal_move_and_collide(rel_vec,test_only,safe_margin,recovery_as_collision)
#	
#	if col:
#		super.singal_move_and_collide(rel_vec - rel_vec.project(col.get_normal()))
#		
#	return col

func ai_fire_column():

	perform_action("UP",true)
	perform_action("ATTACK",true)
	perform_action("ATTACK",false)
	perform_action("UP",false)

func ai_shoot_col(player):
	ai_look_at_player(player)
	ai_fire_column()

func ai_shoot_projectile_dir(dir : String)->void:
	perform_action(dir,true,true)
	perform_action("ATTACK",true)
	perform_action(dir,false)

func ai_shoot_projectile(player):
	if player.position.x < position.x:
		ai_shoot_projectile_dir("LEFT")
	else:
		ai_shoot_projectile_dir("RIGHT")
	
func ai_run_away(player):
	if player.position.x < position.x:
		perform_action("RIGHT",true,true)
	else:
		perform_action("LEFT",true,true)

var ai_ticks : int = 0

func AI(player)->void:
	if run:
		if abs(player.position.x - position.x) > 200:
			perform_action("LEFT",false)
			perform_action("RIGHT",false)
	elif abs(player.position.x - position.x) < abs($col_spawn_position.position.x):
		ai_shoot_col(player)
		ai_run_away(player)
	else:
		if ai_ticks == 4:
			ai_shoot_projectile(player)
	ai_ticks += 1
	ai_ticks = ai_ticks % 5

func collumn_attack()->void:
	$Sprite2D.custom_play("attack")
	state = EntityState.BRICK
	if ($Sprite2D.flip_h and $col_spawn_position.position.x > 0) or (not $Sprite2D.flip_h and $col_spawn_position.position.x < 0):
		$col_spawn_position.position.x *= -1
	spawn_object(collumn,$col_spawn_position.global_position + Vector2(0,50))

#fires the witch projectile using our velocity as direction
func shoot_witch_projectile()->void:
	if ($Sprite2D.flip_h and $col_spawn_position.position.x > 0) or (not $Sprite2D.flip_h and $col_spawn_position.position.x < 0):
		$col_spawn_position.position.x *= -1
	var proj = shoot(witchProjectile,$col_spawn_position.global_position,compute_velocity(velocity))
	proj.witch = self
	$Sprite2D.custom_play("attack")
	state = EntityState.BRICK

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
