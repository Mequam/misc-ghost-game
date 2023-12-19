extends TiredFlightEntity

#this class represents a bat that can expload
#when you press the interact button

class_name BatSplosion

#the damage that we deal when exploading
@export var explosion_damage : int = 2
#the distance above us that we can snap to hang from
@export var hang_distance : float = 10
#represents our "feet" while hanging so the entity
#knows how to position itself while hanging
@export var hang_feet : Node2D

#the hitbox for our exploasion damage
@export var damage_zone : Area2D = null

var dying : bool = false

enum BatSplosionState {
	HANGING = Entity.ENTITY_STATE_COUNT #we hang from the ceiling and do not move save for unhanging
}

#attempts to hang us on an above surface
func hang()->void:
	if $hang_cooldown.time_left > 0: return
	#perform a raycast to determine if we can hang
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(self.global_position,\
			self.global_position + \
			Vector2(0,-self.hang_distance))
	query.collision_mask = ColMath.Layer.TERRAIN | ColMath.ConstLayer.TILE_BORDER
	var result = space_state.intersect_ray(query)
	


	if result:
		self.state = BatSplosionState.HANGING
		self.global_position = result.position - self.hang_feet.global_position + self.global_position
		self.get_sprite2D().custom_play("hang")
		$collision_shape_small.disabled = true
		$collision_shape_big.disabled = false
		self.sync_uposess_spot()
func unhang()->void:
	#energize so we can fly again
	self.un_tired()
	self.state = EntityState.DEFAULT
	self.get_sprite2D().custom_play("fall")
	$collision_shape_small.disabled = false
	$collision_shape_big.disabled = true
	self.sync_uposess_spot()
	$hang_cooldown.start()
func sync_uposess_spot()->void:
	if self.state == BatSplosionState.HANGING:
		$unposSpot.global_position = $unpos_hanging.global_position
		return 
	$unposSpot.global_position = $unpos_normal.global_position
#ensure correct collision mask on possesion
func posses_by(entity)->void:
	super.posses_by(entity)
	self.sync_damage_collision_mask()

func exorcize(offset : Vector2 = Vector2(0,0))->void:
	super.exorcize(offset)
	self.sync_damage_collision_mask()

func unexpload()->void:
	self.get_sprite2D().custom_play("unexpload")
func expload()->void:
	#enable the explosion animation
	self.get_sprite2D().custom_play("expload")
func on_action_press(act : String)->void:
	match act:
		"ATTACK":
			self.expload()
		"JUMP":
			match self.state:
				BatSplosionState.HANGING:
					self.unhang()
				_:
					self.hang()
	super.on_action_press(act)

func on_action_double_press(action : String)->void:
	#double pressing allways releases us from the hanging state
	if self.state == BatSplosionState.HANGING:
		self.unhang()
	super.on_action_double_press(action)

func on_action_released(act : String)->void:
	match act:
		"ATTACK":
			self.unexpload()
	super.on_action_released(act)

func get_exploasion_speed_modifier()->float:
	var anim = get_sprite2D().animation
	if anim == "expload":
		return 5*get_sprite2D().frame+1
	return 1

func get_hang_speed_modifier()->Vector2:
	if $hang_cooldown.time_left > 0:
		return Vector2(1.5,2.5)
	return Vector2(1,1)
func compute_velocity(vel : Vector2)->Vector2:
	if self.get_sprite2D().animation == "no_return" or self.state == BatSplosionState.HANGING:
		return Vector2(0,0)
	return super.compute_velocity(vel)/self.get_exploasion_speed_modifier()*self.get_hang_speed_modifier()

func sync_damage_collision_mask()->void:
	self.damage_zone.collision_mask = ColMath.strip_stationary_bits(self.collision_mask)
	print_debug("syncing collision mask!")

func main_ready()->void:
	super.main_ready()
	self.sync_damage_collision_mask()
	self.get_sprite2D().play("idle")
	self.get_sprite2D().animation_finished.connect(on_anim_finished)
	self.update_animation()
	self.state = EntityState.DEFAULT
func update_animation()->void:
	if self.state == BatSplosionState.HANGING: return 
	super.update_animation()
func on_anim_finished():
	#if we ever get to the point where we expload, we DIE
	match self.get_sprite2D().animation:
		"no_return":
			if self.dying:
				#really launch the player
				$unposSpot.position *= 2
				for body in self.damage_zone.get_overlapping_bodies():
					if body is Entity:
						body.take_damage(self.explosion_damage,self)
			self.dying = true
