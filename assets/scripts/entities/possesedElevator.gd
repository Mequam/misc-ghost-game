extends Npc


#used for the AI of the elevtor
enum PossesedElevatorState {
	FALLING = Entity.ENTITY_STATE_COUNT
}
var ai_vertical_shoot_range : float = 100
var ai_horizontal_shoot_range : float = 500

func set_state(val : int)->void:
	match val:
		PossesedElevatorState.FALLING:
			clear_stored_inputs()
	.set_state(val)

var ai_counter : int = 0
func AI(player):
	if state != PossesedElevatorState.FALLING:
		if ai_counter == 3 and abs(player.position.y - position.y) < ai_vertical_shoot_range and abs(player.position.x - position.x) < ai_horizontal_shoot_range:
			ai_attack_at_player(player)
		elif player.position.y > position.y:
			#use ai_counter == 2 to induce an amount of random delay in this behavior
			if ai_counter == 2 and (player.position.y - position.y) > 100 and abs(player.position.x - position.x) < 100:
				self.state = PossesedElevatorState.FALLING
			perform_action("UP",false)
			perform_action("DOWN",true)
		elif player.position.y < position.y:
			perform_action("DOWN",false)
			perform_action("UP",true)
	ai_counter += 1
	ai_counter %= 4
#wooshes a given entity
func woosh(body)->void:
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
		
		if self.state == PossesedElevatorState.FALLING:
			self.state = EntityState.DEFAULT
	.set_onground(val)

func compute_velocity(vel : Vector2)->Vector2:
	if pressed_inputs["UP"]:
		vel.y -= 1
	else:
		vel.y += 1
		
	if pressed_inputs["DOWN"]:
		vel.y += 1
	return .compute_velocity(vel)
	

var flipped : bool = false
func on_action_press(act):
	print("recived action " + act)
	if act == "LEFT" and not flipped:
		self.scale.x = -1
		flipped = not flipped
	elif act == "RIGHT" and flipped:
		self.scale.x = -1
		flipped = not flipped
	elif act == "ATTACK":
		shoot_bird_things()

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 500
	possesed = false

var entities_to_woosh = []

func _on_wooshfect_body_entered(body):
	if body != self:
		entities_to_woosh.append(body)
func _on_wooshfect_body_exited(body):
	entities_to_woosh.erase(body)


var bird_thing_packed = load("res://scenes/projectiles/flightThingProjectile.tscn")

func shoot_bird_things()->void:
	
	var to_shoot : Vector2
	if not flipped:
		to_shoot = Vector2(1,0)
	else:
		to_shoot = Vector2(-1,0)
	
	var bt = shoot(bird_thing_packed,$batSpawnPoint.global_position,to_shoot)
	
	
	print("projectile layers")
	print(bt.collision_layer)
	print(bt.collision_mask)
	print(collision_layer)
	print(collision_mask)
	$Sprite.play("open",false)


