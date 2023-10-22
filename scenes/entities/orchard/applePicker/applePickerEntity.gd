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

func gen_col_mask()->int:
	return ColMath.Layer.PLAYER | ColMath.Layer.TERRAIN | ColMath.ConstLayer.TILE_BORDER 
func gen_col_layer()->int:
	return ColMath.ConstLayer.ALL_ENEMIES | ColMath.Layer.NON_PLAYER_ENTITY

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
	super.on_action_press(act)
	if act == "ATTACK":
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

func on_col(col)->void:
	if not self.possesed:
		self.entity_ai.ai_on_col(col)
	super.on_col(col)


