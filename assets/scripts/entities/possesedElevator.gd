extends Npc

#wooshes a given entity
func woosh(body)->void:
	print("wooshing " + body.name)
	if body.has_method("move_and_collide"):
		if body.position.x > position.x:
			body.move_and_collide(Vector2(100,0))
		else:
			body.move_and_collide(Vector2(-100,0))

func set_onground(val : bool)->void:
	if pressed_inputs["DOWN"] and not onground:
		for body in entities_to_woosh:
			woosh(body)
		$woosh.play("default")
		entities_to_woosh = []
	.set_onground(val)

func compute_velocity(vel : Vector2)->Vector2:
	if pressed_inputs["UP"]:
		vel.y -= 1
	else:
		vel.y += 1
		
	if pressed_inputs["DOWN"]:
		vel.y += 1
	return .compute_velocity(vel)

func on_action_press(act):
	if act == "LEFT" and not $Sprite.flip_h:
		$Sprite.flip_h = true
	elif act == "RIGHT" and $Sprite.flip_h:
		$Sprite.flip_h = false
	elif act == "ATTACK":
		shoot_bird_things()

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 500
	possesed = false

var entities_to_woosh = []

func _on_wooshfect_body_entered(body):
	if body != self:
		print("adding " + body.name + " to woosh")
		entities_to_woosh.append(body)
var bird_thing_packed = load("res://scenes/projectiles/flightThingProjectile.tscn")

func shoot_bird_things()->void:
	pass
	#var bd = bird_thing_packed.instance() as Projectile
	#bd.global_position = global_position
	#if $Sprite.flip_h:
	#	bd.velocity = Vector2(1,0)
	#else:
#		bd.velocity = Vector2(-1,0)
	
#	get_parent().add_child(bd)
	$Sprite.play("open",false)
