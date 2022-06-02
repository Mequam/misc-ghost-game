extends LRJEntity

#this file is the witch entity

class_name Witch

var collumn = load("res://scenes/hazards/WitchColumn.tscn")


func collumn_attack()->void:
	$Sprite.play("attack")
	state = EntityState.BRICK
	if ($Sprite.flip_h and $col_spawn_position.position.x > 0) or (not $Sprite.flip_h and $col_spawn_position.position.x < 0):
		$col_spawn_position.position.x *= -1
	var obj = spawn_object(collumn,$col_spawn_position.global_position)
	
func on_action_press(act : String)->void:
	match act:
		"ATTACK":
			collumn_attack()
	.on_action_press(act)

func update_animation(event : InputEvent = null)->void:
	if state != EntityState.BRICK:
		.update_animation(event)


func _on_Sprite_animation_finished():
	if $Sprite.animation == "attack":
		state = EntityState.DEFAULT
		update_animation()
