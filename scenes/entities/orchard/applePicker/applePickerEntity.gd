extends TiredFlightEntity

class_name ApplePicker 
@export var apple_detector : Area2D
#represents how many apples we currently have
@export var max_apple_count : int = 3
@export var apple_count : int = 3 :
	set (val):
		#domain enforcement
		if val > max_apple_count:
			val = max_apple_count 
		if val < 0:
			val = 0

		if get_sprite2D():
			get_sprite2D().get_node("apples").visible = val > 0
			if not get_sprite2D().get_node("apples").visible: self.stop_shooting_apples()
		apple_count = val
	get:
		return apple_count

@export var apple_shotgun_projectile : PackedScene	

@export var apple_projectile_speed : Vector2

enum ApplePickerState {
	SHOOTING = ENTITY_STATE_COUNT,
	PICKING
}

#fills the apple basket if there are apple baskets around
func pick()->void:
	var areas = apple_detector.get_overlapping_areas()
	for pickable in areas:
		if pickable is PickableApple:
			self.apple_count += pickable.pick()

	self.state = ApplePickerState.PICKING
	self.get_sprite2D().custom_play("pick")
func start_shooting_apples()->void:
	if get_sprite2D().get_node("apples").visible:
		self.state = ApplePickerState.SHOOTING
		self.get_sprite2D().custom_play("shoot")
	else:
		#if we have no apples, pick apples
		self.pick()
		
func stop_shooting_apples()->void:
	self.state = EntityState.DEFAULT
	self.update_animation()

func on_action_press(act : String)->void:
	print("action press detected with " + act)
	super.on_action_press(act)
	if act == "ATTACK":
		print("starting to shoot apples")
		self.start_shooting_apples()

func on_action_released(act : String)->void:
	super.on_action_released(act)
	if act == "ATTACK":
		self.stop_shooting_apples() #also sets our state to default
func update_animation()->void:
	if self.state != ApplePickerState.SHOOTING:
		super.update_animation()
	
	#make sure that our sub sprite also flips when we flip
	get_sprite2D().get_node("apples").flip_h = get_sprite2D().flip_h
func main_process(delta)->void:
	if self.state != ApplePickerState.SHOOTING:
		super.main_process(delta)
func on_anim_finished(anim : StringName):
	match anim:
		"shoot":
			self.apple_count -= 1
			var flip = -1 if self.get_sprite2D().flip_h else 1
			self.shoot(self.apple_shotgun_projectile,self.global_position,self.apple_projectile_speed * Vector2(flip,-1))
			self.singal_move_and_collide(Vector2.LEFT*flip*self.run_speed.x*60)
		"pick":
			#pretty much does what we want it to even if the name is odd
			self.stop_shooting_apples()
			if not self.possesed:
				self.perform_action("ATTACK",false)

func compute_velocity(vel : Vector2)->Vector2:
	return super.compute_velocity(vel*int(self.state != ApplePickerState.PICKING))

func main_ready()->void:
	get_sprite2D().get_node("AnimationTree").animation_finished.connect(self.on_anim_finished)
	super.main_ready()
	self.possesed = false
#AI code

func on_col(col)->void:
	if not self.possesed:
		var norm = col.get_normal()
		if norm.x > norm.y*2:
			self.perform_action("UP",true)

var shoot_threshold = 300

#returns a pickable apple that we can target to re-fill
func ai_get_apple_target()->PickableApple:
	var nodes = get_tree().get_nodes_in_group("pickable_apples")
	var best : float = 99999**2
	var best_node : PickableApple = null
	for apple in nodes:
		if apple.is_harvestable():
			var dist = apple.global_position.distance_squared_to(self.global_position)
			if dist < best:
				best = dist 
				best_node = apple
	return best_node

var ai_apple_target = null 

func AI(player)->void:
	#stop flying up if we are going in the up direction
	if self.pressed_inputs["UP"]:
		self.perform_action("UP",false)
	if self.apple_count > 0:
		var distance_squared_to_player = self.global_position.distance_squared_to(player.global_position)
		if  distance_squared_to_player < shoot_threshold**2 and not self.pressed_inputs["ATTACK"]:
			#shoot the apples at the player
			#remove the left and right inputs
			self.clear_stored_inputs()
			self.perform_action("ATTACK",true)
		elif distance_squared_to_player > shoot_threshold**2:
			if self.pressed_inputs["ATTACK"]:
				self.perform_action("ATTACK",false)
				await get_tree().process_frame

			if player.global_position.x < self.global_position.x and not self.pressed_inputs["LEFT"]:
				self.perform_action("RIGHT",false)
				self.perform_action("LEFT",true)
			elif player.global_position.x > self.global_position.x and not self.pressed_inputs["RIGHT"]:
				self.perform_action("LEFT",false)
				self.perform_action("RIGHT",true)
	else:
		if ai_apple_target == null:
			self.ai_apple_target = self.ai_get_apple_target()
		else:
			#if we are within range, attack the target to harvest it 
			if self.global_position.distance_squared_to(self.ai_apple_target.global_position) < 100**2:
				self.perform_action( "ATTACK",true )
				self.ai_apple_target = null
			else:
				#it is above us, move up (it has to be above or bellow since our x is aligned but we are not colliding)
				if abs(self.global_position.x - self.ai_apple_target.global_position.x) < 50:
					self.perform_action("RIGHT",false)
					self.perform_action("LEFT",false)
					self.perform_action("UP",true)
				else:
					if self.ai_apple_target.global_position.x < self.global_position.x and not self.pressed_inputs["LEFT"]:
						self.perform_action("RIGHT",false)
						self.perform_action("LEFT",true,true)
					elif self.ai_apple_target.global_position.x > self.global_position.x and not self.pressed_inputs["RIGHT"]:
						self.perform_action("LEFT",false)
						self.perform_action("RIGHT",true,true)

		


