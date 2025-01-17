extends Entity

# this script represents an enemy that grows out of the ground
# the current art looks like grape soda :>)

class_name GroundHogEnemy

@export var growth_speed : float = 0.01
#the highest we can grow too
@export var max_growth : float = 100.0
#the lowest we can grow to
@export var min_growth : float = 10.0
#if true we set max growth from the current scale of the entity on ready
@export var set_max_growth : bool = true

@export var sprite_bone : Node2D
var height : float :
	set(val):
		height = val
		self.scale.y = val
		self.align_after_image_mesh()
	get:
		return self.scale.y

func align_after_image_mesh()->void:
	if self.possesed and self.possesed_entity.ghost_after_effect:
		self.possesed_entity.ghost_after_effect.offset = Vector2(0,-85*self.height).rotated(self.rotation)
		self.possesed_entity.ghost_after_effect.after_scale = Vector2(self.height*0.5+1.1,lerpf(1,1.01,self.height/self.max_growth))
		self.possesed_entity.ghost_after_effect.after_image_frequency = lerpf(5,100,self.height / self.max_growth)

func _ready() -> void:
	super._ready()
	if self.set_max_growth:
		self.max_growth = self.height

#storage for the previous after image nodes we change
var previous_offset : Vector2
var previous_scale : Vector2
var previous_frequency : float
func posses_by(entity)->void:
	super.posses_by(entity)
	
	previous_offset = self.possesed_entity.ghost_after_effect.offset
	previous_scale = self.possesed_entity.ghost_after_effect.after_scale
	previous_frequency = self.possesed_entity.ghost_after_effect.after_image_frequency
	
	self.align_after_image_mesh()

func exorcize(offset : Vector2 = Vector2(0,0))->void:
	if self.possesed and self.possesed_entity.ghost_after_effect:
		#re-align the mesh
		print_debug("re-aligning the mesh")
		self.possesed_entity.ghost_after_effect.offset = previous_offset
		self.possesed_entity.ghost_after_effect.after_scale = previous_scale
		self.possesed_entity.ghost_after_effect.after_image_frequency = previous_frequency

	super.exorcize(offset)

func on_modulate_timer_out()->void:
	super.on_modulate_timer_out()
	print_debug("ouch! -grape soda ghost")


func _process(_delta: float) -> void:
	var input_direction : Vector2 = self.local_player_input_direction()

	if input_direction.y < 0 and self.max_growth >= self.height:
		self.height += self.growth_speed
	if input_direction.y > 0 and self.height >= 0:
		self.height -= self.growth_speed

	#collision_shape.shape.size.y = self.height
