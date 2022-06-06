extends LRJEntity

#this file is the witch entity

class_name Witch

var collumn = load("res://scenes/hazards/WitchColumn.tscn")
var witchProjectile = load("res://scenes/projectiles/witchProjectile.tscn")



func ai_fire_column():
	perform_action("ATTACK",true)
	perform_action("ATTACK",false)

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
		if abs(player.position.x - position.x) > 500:
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
	$Sprite.play("attack")
	state = EntityState.BRICK
	if ($Sprite.flip_h and $col_spawn_position.position.x > 0) or (not $Sprite.flip_h and $col_spawn_position.position.x < 0):
		$col_spawn_position.position.x *= -1
	var obj = spawn_object(collumn,$col_spawn_position.global_position)

func shoot_witch_projectile()->void:
	if ($Sprite.flip_h and $col_spawn_position.position.x > 0) or (not $Sprite.flip_h and $col_spawn_position.position.x < 0):
		$col_spawn_position.position.x *= -1
	shoot(witchProjectile,$col_spawn_position.global_position,compute_velocity(velocity))
	$Sprite.play("attack")
	state = EntityState.BRICK

func on_action_press(act : String)->void:
	match act:
		"ATTACK":
			if run:
				shoot_witch_projectile()
			else:
				collumn_attack()
	.on_action_press(act)

func update_animation(event : InputEvent = null)->void:
	if state != EntityState.BRICK and state != EntityState.DAMAGED:
		.update_animation()

func _on_Sprite_animation_finished():
	if $Sprite.animation == "attack":
		if state != EntityState.DAMAGED:
			state = EntityState.DEFAULT
			update_animation()
