extends LRJEntity

#this file is the witch entity

class_name Witch

@export var collumn : PackedScene
@export var witchProjectile : PackedScene

var ai_ticks : int = 0

func perform_action(act : String,pressed : bool,double_press : bool = false,echo : bool = false)->void:
	print("performing action!")
	super.perform_action(act,
		pressed,
		double_press,
		echo)
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
